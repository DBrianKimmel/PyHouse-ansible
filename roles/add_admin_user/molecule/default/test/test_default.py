import os
import pytest

@pytest.mark.parametrize('pkg', [
  'httpd',
  'firewalld'
])
def test_pkg(host, pkg):
    package = host.package(pkg)

    assert package.is_installed

@pytest.mark.parametrize('svc', [
  'httpd',
  'firewalld'
])
def test_svc(host, svc):
    service = host.service(svc)

    assert service.is_running
    assert service.is_enabled

@pytest.mark.parametrize('file, content', [
  ("/etc/firewalld/zones/public.xml", "<service name=\"http\"/>"),
  ("/var/www/html/index.html", "Managed by Ansible")
])
def test_files(host, p_file, content):
    l_file = host.file(p_file)

    assert l_file.exists
    assert l_file.contains(content)



### END DBK


failed: [localhost] (item={'started': 1, 
                           'finished': 0, 
                           'ansible_job_id': '8267846781.76951', 
                           'results_file': '/home/briank/.ansible_async/8267846781.76951', 
                           'changed': True, 
                           'failed': False, 
                           'item': {'capabilities': ['SYS_ADMIN'], 
                                    'command': '/lib/systemd/systemd', 
                                    'image': 'debian', 
                                    'name': 'debian', 
                                    'pre_build_image': True, 
                                    'tmpfs': ['/run', '/tmp'], 
                                    'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 
                           'ansible_loop_var': 'item'})
 => 
        {"ansible_job_id": "8267846781.76951", 
         "ansible_loop_var": "item", 
         "attempts": 1, 
         "changed": false, 
         "finished": 1, 
         "item": {"ansible_job_id": "8267846781.76951", "ansible_loop_var": "item", "changed": true, "failed": false, "finished": 0,
         "item": {"capabilities": ["SYS_ADMIN"], "command": "/lib/systemd/systemd", "image": "debian", "name": "debian", "pre_build_image": true, "tmpfs": ["/run", "/tmp"],
         "volumes": ["/sys/fs/cgroup:/sys/fs/cgroup:ro"]}, "results_file": "/home/briank/.ansible_async/8267846781.76951", "started": 1},
         "msg": "Error starting container 65701693891da6c0375da384bfd708b11bc4264de28e85934eb2a57711ea19c7: 
                    400 Client Error: Bad Request (\"OCI runtime create failed: container_linux.go:349: starting container process caused
                     \"exec: \\\"/lib/systemd/systemd\\\": stat /lib/systemd/systemd: no such file or directory\": unknown\")"}
        
###