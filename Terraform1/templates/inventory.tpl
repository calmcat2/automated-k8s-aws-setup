[k8s_master]
${k8s-master_ips}


[k8s_workers]
%{ for ip in worker-node_ips ~}
${ip}
%{ endfor ~}