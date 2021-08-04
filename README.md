# ansible-runner-with-ubi8-sample

[![](https://img.shields.io/docker/image-size/skyjokerxx/ansible-runner-with-ubi8-sample?sort=date&style=for-the-badge)](https://hub.docker.com/r/skyjokerxx/ansible-runner-with-ubi8-sample)

This is a sample to build an ansible runner container with ubi8.  
The ansible runner container will build based on [ansible-runner](https://github.com/ansible/ansible-runner).

## Requirements

* podman
* Python >= 3.6

## How to build the container image

Clone this repository into your environment and move.

```
$ git clone https://github.com/sky-joker/ansible-runner-with-ubi8-sample.git
$ cd ansible-runner-with-ubi8-sample/
```

Build a container image with podman.  
Here, I'll set the namespace for the docker hub to push the image to the [docker hub](https://hub.docker.com/).

```
$ podman build . -t skyjokerxx/ansible-runner-with-ubi8-sample:latest
```

Login the docker hub with your account after building the image.

```
$ podman login docker.io
Username: enter your account name
Password: enter your account password
Login Succeeded!
```

Push the builded image to the docker hub.

```
$ podman push skyjokerxx/ansible-runner-with-ubi8-sample:latest
```

## How to run a playbook with a self-made execution environment(EE) via ansible-navigator

You can run a playbook with the EE by using the [ansible-navigator](https://github.com/ansible/ansible-navigator).  
The following are steps to run a playbook.

Create a virtual environment for python and install the ansible-navigator.

```
$ python3 -m venv venv
$ . venv/bin/activate
(venv)$ pip install ansible-navigator
(venv)$ ansible-runner --version
2.0.1
```

Run a container with the image via the ansible-navigator.

```
$ ansible-navigator --eei skyjokerxx/ansible-runner-with-ubi8-sample:latest
(snip)
? Please select an image:
    registry.access.redhat.com/skyjoker/ansible-runner-with-ubi8-sample:latest
    registry.redhat.io/skyjoker/ansible-runner-with-ubi8-sample:latest
  ▸ docker.io/skyjokerxx/ansible-runner-with-ubi8-sample:latest
(snip)
```

Enter the run command in TUI mode.

[![asciicast](https://asciinema.org/a/428894.svg)](https://asciinema.org/a/428894)
