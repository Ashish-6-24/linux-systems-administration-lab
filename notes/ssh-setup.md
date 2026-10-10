# SSH Setup AWS EC2 Ubuntu

Configure **SSH key-based authentication** for secure remote administration of an Ubuntu server on **AWS EC2**. Verify network access, the OpenSSH service, and a successful login before applying host firewall changes.

## 1. Check AWS access

- Confirm the EC2 instance is running and its status checks pass.
- In its **Security Group**, allow inbound **SSH / TCP 22** from a trusted source IP. Avoid `0.0.0.0/0` for routine access.
- Locate the private key that matches the EC2 key pair. AWS does not let the original private key be downloaded again; protect the existing copy and never commit it to Git.

## 2. Set the private-key permissions

Run on the administrator workstation. Replace the placeholder with the actual key path:

```bash
chmod 400 "$HOME/.ssh/<ec2-private-key>.pem"
```

## 3. Connect to Ubuntu

```bash
ssh -i "$HOME/.ssh/<ec2-private-key>.pem" ubuntu@<EC2_PUBLIC_IP>
```

Replace `<EC2_PUBLIC_IP>` and the key path with the values for the instance. Use the correct login username for the selected AMI; `ubuntu` is common for standard Ubuntu EC2 images. On first connection, verify the host fingerprint through a trusted source before accepting it.

## 4. Verify the session

Run these commands after login:

```bash
whoami
hostname
cat /etc/os-release
uptime
systemctl is-active ssh
```

Confirm that the session reaches the expected Ubuntu instance and that the SSH service reports `active`. Record the actual environment and results in the lab notes; do not substitute example output for observed results.

## 5. Test after UFW configuration

Before enabling UFW, ensure an SSH allow rule exists. Keep the original session open, then use a **new terminal** to open a second SSH connection. Close the original session only after the new connection succeeds.

```bash
sudo ufw allow OpenSSH
sudo ufw status verbose
```

If UFW has not yet been enabled, follow [`ufw-firewall.md`](ufw-firewall.md) for the full firewall procedure. Confirm that both the AWS Security Group and UFW permit the connection.

## Troubleshooting

| Symptom | Checks |
|---|---|
| Connection times out | Instance state and public IP, Security Group inbound rule, source IP, routes, and host firewall |
| `Permission denied (publickey)` | Correct key file, login username, matching EC2 key pair, and key permissions |
| Connection refused | Instance reachability and whether OpenSSH is listening on TCP 22 |
| Host-key warning | Verify whether the instance was replaced or its host key changed; confirm identity before updating `known_hosts` |

For additional diagnostics, use `ssh -v -i "$HOME/.ssh/<ec2-private-key>.pem" ubuntu@<EC2_PUBLIC_IP>` to inspect client-side connection details. Review output before sharing it, and redact public addresses or other sensitive information where appropriate.

## Security checklist

- [ ] Restrict Security Group SSH access to a trusted source IP.
- [ ] Keep the private key outside the repository and protect it with restrictive file permissions.
- [ ] Verify the host fingerprint before accepting a new host.
- [ ] Test a fresh SSH connection after changing firewall rules.
- [ ] Document the actual result and troubleshooting steps.
