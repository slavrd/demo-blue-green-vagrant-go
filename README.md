# Blue / Green deployment demo

A simple Blue / Green deployment demo. It includes a Vagrant project to build a VM on which two versions of a simple Golang app are running. On the VM there is also a ngnix server that simulates the client ingress point by routing traffic to the application instances.
