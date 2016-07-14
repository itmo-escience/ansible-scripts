#!/home/max/anaconda2/bin/python
from flask import Flask, jsonify, abort, request
from jinja2 import Template
from subprocess import Popen, PIPE
import os

app = Flask(__name__, static_url_path="")

vms = {
    'ram': '8192',
    'cpus': '4',
    'machine_count': '5'
}

template = Template("""---
{% for id in range(1, machine_count+1) %}
- name: {{ my_host_name }}{{ id }}
  ram: {{my_ram}}
  cpus: {{my_cpus}}
  ip: {{ my_base_ip_for_vms }}{{ id }}

{% endfor %}

""")

result = template.render(machine_count=int(vms['machine_count']), my_ram=vms['ram'], my_cpus=vms['cpus'],
                         my_host_name='{{my_host_name}}', my_base_ip_for_vms='{{my_base_ip_for_vms}}')


@app.route('/rest/vms/status', methods=['GET'])
def getStatus():
    print result
    return result


@app.route('/rest/vms/apply', methods=['GET'])
def applyConf():
    result = template.render(machine_count=int(vms['machine_count']), my_ram=vms['ram'], my_cpus=vms['cpus'],
                             my_host_name='{{my_host_name}}', my_base_ip_for_vms='{{my_base_ip_for_vms}}')
    print result


    os.chdir('/home/max/IdeaProjects/ansible-bdas/ansible-bdas')

    with open('templates/cluster-description.yml.j2', 'w') as file:
        file.write(result)

    # p = subprocess.check_output(["ansible-playbook", "deploy-cluster.yml"])
    p = Popen(["ansible-playbook", "deploy-cluster.yml"], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    output, err = p.communicate(b"input data that is passed to subprocess' stdin")
    rc = p.returncode

    return output, err, rc


@app.route('/rest/vms/update', methods=['PUT'])
def updateConf():
    if not request.json:
        abort(400)

    vms['ram'] = request.json.get('ram')
    vms['cpus'] = request.json.get('cpus')
    vms['machine_count'] = request.json.get('machine_count')

    print('Updated! Current vms = ' + str(vms))

    return jsonify({'changed': 'true', 'vms': vms})

@app.route('/rest/vms/updateAndApply', methods=['PUT'])
def updateAndApplyConf():
    if not request.json:
        abort(400)

    vms['ram'] = request.json.get('ram')
    vms['cpus'] = request.json.get('cpus')
    vms['machine_count'] = request.json.get('machine_count')

    print('Updated! Current vms = ' + str(vms))

    output, err, rc = applyConf()

    if rc is not 0:
        return jsonify({'vms': vms, 'output': str(output), 'err': str(err), 'rc': str(rc)})


    return jsonify({'vms': vms, 'changed': 'true'})


if __name__ == '__main__':
    app.run()
