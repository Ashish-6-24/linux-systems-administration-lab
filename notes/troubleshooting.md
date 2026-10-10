# Linux Troubleshooting Runbook  AWS EC2

Use this runbook to diagnose Ubuntu Linux issues on AWS EC2 with an evidence-first workflow. Inspect the system, identify the failing layer, make one controlled change and verify recovery.

## Troubleshooting Workflow

1. **Define the symptom:** Record the error, time, impact, and any recent change.
2. **Collect evidence:** Capture relevant command output before changing the system.
3. **Isolate the layer:** Check the workstation, AWS network controls, UFW, Linux service, or resource involved.
4. **Apply one controlled fix:** Avoid unrelated changes and broad process-killing commands.
5. **Verify recovery:** Repeat the original test and confirm the expected result.
6. **Document the outcome:** Record the cause, fix, verification, and any remaining uncertainty.

## Quick Baseline

Run these commands on the Ubuntu EC2 instance. Use `sudo` where required and record the actual output.

```bash
whoami
hostnamectl
cat /etc/os-release
uptime
free -h
df -h
ip -br addr
ip route
systemctl --failed
sudo ufw status verbose
```

## Common Issues and Diagnostic Steps

### 1. SSH Connection Times Out

Check the network path before changing SSH configuration.

```bash
# On the EC2 instance, if console access is available
systemctl is-active ssh
sudo ss -tulpn | grep ':22'
sudo ufw status numbered

# From the workstation
ssh -v -i "$HOME/.ssh/<ec2-private-key>.pem" ubuntu@<EC2_PUBLIC_IP>
```

Verify the EC2 instance state and status checks, public IP or DNS name, route configuration, and the Security Group inbound rule. Permit TCP port 22 only from a trusted source IP. Check network ACLs if applicable. Confirm that UFW allows SSH and that OpenSSH is listening.

### 2. SSH Reports `Permission denied (publickey)`

```bash
chmod 400 "$HOME/.ssh/<ec2-private-key>.pem"
ssh  -i "$HOME/.ssh/<ec2-private-key>.pem" ubuntu@<EC2_PUBLIC_IP>
```

Confirm the private key matches the EC2 key pair and use the correct login username for the AMI. Check the verbose SSH output for the authentication step that failed. Do not upload or commit the private key.

### 3. SSH Service Is Inactive

```bash
sudo systemctl status ssh --no-pager
sudo journalctl -u ssh -n 50 --no-pager
sudo systemctl restart ssh
systemctl is-active ssh
```

Review the service status and logs before restarting. Restart only after identifying a plausible cause. Verify a new SSH connection before closing any working session.

### 4. UFW Blocks Expected Traffic

```bash
sudo ufw status verbose
sudo ufw status numbered
```

Confirm the intended rule is present and applies to the correct port and source. Before enabling UFW, add and verify the SSH allow rule. Keep the current SSH session open and test a second connection after firewall changes. If remote access is lost, use the AWS-supported console or recovery access path; do not guess at firewall rules.

### 5. DNS Lookup or Outbound Connectivity Fails

```bash
ip -br addr
ip route
getent hosts example.com
curl -I --max-time 10 https://example.com
```

Determine whether the interface has an address, a default route exists, DNS resolves, and outbound HTTPS works. Review subnet routing, internet/NAT gateway configuration, security controls, and resolver settings as appropriate. A failed test to one website does not alone prove that all connectivity is unavailable.

### 6. Disk Space Is Low ( Linux Volume Maanagement ) 

```bash
df -h
lsblk
du -xhd1 /var 2>/dev/null | sort -h
```

Use `df -h` to identify a full filesystem, then inspect likely directories with `du`. Check logs, package caches, and temporary files before deleting anything. Do not remove files from system directories without confirming their purpose and impact.

References : [Day 13 – Project Documentation](https://github.com/Ashish-6-24/90DaysOfDevOps/tree/master/2026/day-13)
### 7. Memory Pressure or Unexpected Process Usage

```bash
free -h
top
ps aux --sort=-%cpu | head -n 10
ps aux --sort=-%mem | head -n 10
```

Identify the process consuming resources and determine whether the usage is expected. Inspect the process and relevant logs before acting. For a lab exercise, start a harmless test process such as `sleep 300`, record its PID, inspect it, stop that exact PID, and verify it has exited. Do not terminate production or system processes without understanding their role.

### 8. A systemd Service Fails

```bash
systemctl --failed
sudo systemctl status <service-name> 
sudo journalctl -u <service-name> -n 50 
```

Replace `<service-name>` with the relevant unit. Read the status and logs, check the service configuration and dependencies, and apply a targeted correction. Confirm the service state and dependent functionality afterward.

### 9. Package Installation Fails

```bash
sudo apt-get  update
```

Review the full error message. Check DNS, outbound connectivity, repository configuration, available disk space, and the system clock where relevant. Retry only after addressing the reported cause; do not disable package-signature verification to bypass an error.

Note: ```get``` will provide the latest updated available . 
## Recovery Verification

After a fix, repeat the original failed test and confirm the expected service or system state. Capture the relevant evidence and document the result using this template:

```text
Symptom:
Impact:
Evidence collected:
Likely cause:
Change applied:
Verification performed:
Result:
Follow-up or remaining risk:
```

## Operational Safety

- Restrict AWS Security Group SSH access to a trusted source IP.
- Preserve an existing working SSH session when testing firewall changes.
- Prefer targeted diagnostics and reversible changes.
- Avoid broad commands such as `pkill <name>` when a specific process ID can be verified and used.
- Review cleanup scripts before execution; verify each path before deleting files.
- Do not include private keys, credentials, tokens, or unnecessary AWS account details in screenshots, logs, or Git history.

## Related Documentation

- [`linux-command-cheatsheet.md`](linux-command-cheatsheet.md) — Linux system administration and diagnostics commands.
- [`ssh-setup.md`](ssh-setup.md) — AWS EC2 SSH key-based authentication and OpenSSH validation.
- [`ufw-firewall.md`](ufw-firewall.md) — UFW rules and host-level firewall verification.

