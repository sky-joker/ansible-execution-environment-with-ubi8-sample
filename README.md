# ansible-runner-with-ubi8-sample

[![](https://img.shields.io/docker/v/skyjokerxx/ansible-runner-with-ubi8-sample/latest?style=for-the-badge)](https://hub.docker.com/r/skyjokerxx/ansible-runner-with-ubi8-sample)

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

## How to run a playbook with a self-made runner container image via ansible-navigator

You can run a playbook with the runner container by using the [ansible-navigator](https://github.com/ansible/ansible-navigator).  
The following are steps to run a playbook.

Create a virtual environment for python and install the ansible-navigator.

```
$ python3 -m venv venv
$ . venv/bin/activate
(venv)$ pip install ansible-navigator
(venv)$ ansible-runner --version
2.0.1
```

Run the runner container via the ansible-navigator.

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

## How to build an execution environment(EE) with the runner image

You can build an execution environment(EE) with the runner image by using the [ansible-builder](https://github.com/ansible/ansible-builder).  
Here example, I'll explain how to build a new EE that included [community.vmware](https://github.com/ansible-collections/community.vmware).  

First, create execution-environment.yml that requires when building.  

**execution-environment.yml**

```yaml
---
version: 1
build_arg_defaults:
  EE_BASE_IMAGE: 'skyjokerxx/ansible-runner-with-ubi8-sample:latest'

dependencies:
  galaxy: requirements.yml
  python: requirements.txt
```

Set a base container image to EE_BASE_IMAGE that you'd like to use.  
Specify the requirements.yml and requirements.txt to install community.vmware and pyvmomi.  
There are still other options, so please see the tool [documentation](https://ansible-builder.readthedocs.io/en/latest/definition.html).

**requirements.yml**

```yaml
---
collections:
  - name: community.vmware
```

**requirements.txt**

```
pyvmomi
```

Run the ansible-builder command to build a new EE.

```
$ ansible-builder build -t new-ee:latest
Running command:
  podman build -f context/Containerfile -t new-ee:latest context
(snip)
$ podman images | grep new-ee
localhost/new-ee                                      latest  77f152bfa911  4 minutes ago  864 MB
```

You can also run a playbook with the EE and ansible-navigator on your local environment even when you will not pull container images from a remote repository.

[![asciicast](https://asciinema.org/a/429397.svg)](https://asciinema.org/a/429397)
