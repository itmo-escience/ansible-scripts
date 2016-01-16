import sys
import subprocess

if name == "__main__":

	if len(sys.argv) > 1 and sys.argv[1].endswith(".yml"):
		args = ['ansible-playbook'] + sys.argv[1:]
	else:
		args = ['ansible-playbook', 'site.yml'] + sys.argv[1:]
    try:
        with subprocess.Popen(args, stdout=subprocess.PIPE) as process:
            for line in iter(process.stdout.readline, b''):
                print(line)
    except Exception as err:
        print("An error appeared")
        print(err)
        print("exiting...")
        sys.exit(2)

    if process.returncode != 0:
        print("Program is terminated unsuccessfully. Please, see the log to get more details")
        sys.exit(1)