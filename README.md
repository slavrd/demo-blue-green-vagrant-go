# Blue / Green deployment demo

A simple Blue / Green deployment demo.

It includes a Vagrant project to build a VM on which two versions of a simple Golang app are running. On the VM there is also a nginx server that simulates the client ingress point by routing traffic to the application instances.

## Prerequisites

* Install VirtualBox - [instructions](https://www.virtualbox.org/wiki/Downloads)
* Install Vagrant - [instructions](https://www.vagrantup.com/downloads.html)

## Running the demo

* Build the Vagrant project - `vagrant up`
  * (optional) setting the environment variable `skip_go` will make Vagrant skip the Golang installation in order to build the project faster - `skip_go=1 vagrant up`
* Login to the VM - `vagrant ssh`
* Destroy the VM - `vagrant destroy`

The following port forwarding will be configured:

* host `8000` -> guest `8000`
* host `8010` -> guest `8010`
* host `8080` -> guest `80`

The `blue (v0.1.0)` version of the app will already be downloaded and started on port `8000`.

You can download and start the `green (v0.2.0)` version on port `8010` by logging to the VM and using the `/vagrant/ops/scripts/deploy-apps.sh` like:

`/vagrant/ops/scripts/deploy-apps.sh v0.2.0 /opt/green/ 8010`

To use the provided nginx configuration you need to bind the application instances to ports `8000` and `8010`.

Then the application instances can be reached from the host like:

* `localhost:8000` - the blue version
* `localhost:8010` - the green version
* `localhost:8080` - the nginx server, which will route the traffic according to its current configuration

To switch the nginx traffic between the app versions the script `ops/scripts/switch-nginx-traffic.sh` can be used as follows:

```Bash
vagrant ssh # Login to the VM
cd /vagrant/ops/scripts # go to the shared Vagrant folder
./switch-nginx-traffic.sh blue-green # switch the traffic to both versions
./switch-nginx-traffic.sh green # switch traffic to the green version
./switch-nginx-traffic.sh blue # switch traffic to the blue version
```

## The Golang app

A very simple application that serves a static web page with a user provided message. By default it binds to `0.0.0.0:8000`.

### Building the app

* Install [Golang](https://golang.org/dl/) or use the Vagrant machine
* Go the `demosrv/` folder and run `go build`. If using Vagrant VM the shared folder is `/vagrant/demosrv`. The executable will be created in the folder.

### Using the app

* `./demosrv` - start the app with defaults

Available flags:

* `-h` - display flags usage and defaults
* `-p <port>` - Bind the application to the specified port
* `-m <string>` - Text to display on the web page

Example:

`./demosrv -p 8010 -m "my message"` - start the app on `0.0.0.0:8010` and set the text on the web page to `my message`
