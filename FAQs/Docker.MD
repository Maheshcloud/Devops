1. CMD vs EntryPoint: 
The ENTRYPOINT specifies a command that will always be executed when the container starts.
The CMD specifies arguments that will be fed to the ENTRYPOINT.
If you want to make an image dedicated to a specific command you will use ENTRYPOINT ["/path/dedicated_command"]
Otherwise, if you want to make an image for general purpose, you can leave ENTRYPOINT unspecified and use CMD ["/path/dedicated_command"] as you will be able to override the setting by supplying arguments to docker run.

2. Remove unused objects at a time:
docker system prune -a

3. Network driver summary:
User-defined bridge networks are best when you need multiple containers to communicate on the same Docker host.
Host networks are best when the network stack should not be isolated from the Docker host, but you want other aspects of the container to be isolated.
Overlay networks are best when you need containers running on different Docker hosts to communicate, or when multiple applications work together using swarm services.
Macvlan networks are best when you are migrating from a VM setup or need your containers to look like physical hosts on your network, each with a unique MAC address.
Third-party network plugins allow you to integrate Docker with specialized network stacks.

