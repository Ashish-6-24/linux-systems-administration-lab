# UFW Firewall Configuration  Ubuntu on AWS EC2

Configure and validate the Ubuntu host firewall with **Uncomplicated Firewall (UFW)** while preserving SSH access to the AWS EC2 instance.

## Objective

- Apply host-level network access control on Ubuntu Linux.
- Deny unsolicited inbound connections and permit outbound connections by default.
- Allow SSH before enabling the firewall.
- Verify firewall status, rules, and remote access.

## 1. Check the Current Configuration

Run the following commands on the EC2 instance and record the actual output.

```bash
sudo ufw status verbose
sudo ufw status numbered
sudo ss -tulpn
```

If UFW is already active, review the existing rules before changing them.

## 2. Configure Default Policies

**Keep the current SSH session open throughout configuration.** Confirm that the AWS Security Group permits TCP port 22 from a trusted source IP.

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw status verbose
```

Confirm that the SSH rule appears before enabling UFW. If SSH uses a non-default port, allow the configured port instead of relying only on the `OpenSSH` application profile.

## 3. Enable UFW

```bash
sudo ufw enable
sudo ufw status verbose
sudo ufw status numbered
```

Expected configuration: UFW is active, incoming traffic is denied by default, outgoing traffic is allowed by default, and the intended SSH rule is present. Verify the actual output rather than assuming the expected state.

## 4. Verify SSH Access

From a **second terminal on the administrator workstation**, open a new SSH connection to the instance. Keep the original session open until the new connection succeeds.

```bash
ssh -i "$HOME/.ssh/<ec2-private-key>.pem" ubuntu@<EC2_PUBLIC_IP>
```

Replace the placeholders with the correct key path, username, and public IP. Restrict SSH access in the AWS Security Group to a trusted source IP; UFW and Security Groups operate at different layers, and both must permit the connection.

## 5. Inspect and Manage Rules

```bash
sudo ufw status verbose
sudo ufw status numbered
sudo ufw show added
sudo ufw allow 80/tcp       # Example: allow HTTP only when required
sudo ufw delete <RULE_NUMBER>
```

Review rules before adding or deleting them. Rule numbers can change after a deletion, so re-run `sudo ufw status numbered` before selecting another rule. Do not add application ports unless the workload requires them.

## 6. Troubleshoot Connectivity

| Symptom | Checks |
|---|---|
| SSH connection times out | EC2 state and address, Security Group inbound TCP 22 rule, routing, host firewall and network reachability |
| SSH returns `Permission denied` | Username, private-key selection, key file permissions, and EC2 key-pair association |
| UFW blocks a required service | `sudo ufw status numbered`; confirm the intended port and source before adding a narrow rule |
| UFW is inactive | Check `sudo ufw status verbose` and review the steps used to enable it |
| Rule change causes concern | Keep the original SSH session open, inspect rules, and test a new connection before closing it |

Collect evidence before changing rules. Prefer the narrowest source address and port that satisfy the requirement. Avoid exposing SSH to `0.0.0.0/0` simply to make connectivity work.

## 7. Validation Checklist

- [ ] Checked the current UFW status and existing rules.
- [ ] Confirmed the AWS Security Group allows SSH from a trusted source IP.
- [ ] Set the intended default inbound and outbound policies.
- [ ] Added the SSH allow rule before enabling UFW.
- [ ] Enabled UFW and captured its actual status and rule list.
- [ ] Opened a second SSH session successfully after enabling the firewall.
- [ ] Recorded any troubleshooting steps and their results.
- [ ] Captured `screenshots/ufw-firewall.png` without exposing credentials or unnecessary account details.

## Operational Notes

- **Technology:** Ubuntu Linux, UFW, AWS EC2, AWS Security Groups, OpenSSH, TCP/IP, cloud security, and Linux system administration.
- **Purpose:** Apply host firewall rules, validate remote administration, and troubleshoot network access.
- **Evidence:** Replace expected states with observations from the actual lab. Do not claim a rule or test succeeded until it has been verified.

Related documentation: [`ssh-setup.md`](ssh-setup.md), [`linux-command-cheatsheet.md`](linux-command-cheatsheet.md), and [`troubleshooting.md`](troubleshooting.md).
