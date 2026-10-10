# Linux Command Cheat Sheet AWS EC2

Use this reference to practise **Linux system administration, DevOps operations, AWS EC2 troubleshooting, Bash, systemd, SSH, UFW, TCP/IP networking, DNS, process management and disk/memory monitoring**.

Run each command on the lab instance, check its output, and replace `Record your result` with a brief observation from your own run. Do not report commands as tested until you have executed them. Some commands may require `sudo` or optional packages.

## 1. Inspect the system

| # | Command | Purpose | Lab observation |
|---:|---|---|---|
| 1 | `whoami` | Display the current user. | Record your result |
| 2 | `id` | Show UID, GID, and group membership. | Record your result |
| 3 | `hostnamectl` | Inspect hostname and OS context. | Record your result |
| 4 | `cat /etc/os-release` | Identify the Linux distribution and version. | Record your result |
| 5 | `uname -r` | Display the running kernel version. | Record your result |
| 6 | `uptime` | Check uptime and load averages. | Record your result |
| 7 | `date` | Display the system date and time. | Record your result |
| 8 | `pwd` | Show the current working directory. | Record your result |

## 2. Inspect files, storage, and permissions

| # | Command | Purpose | Lab observation |
|---:|---|---|---|
| 9 | `ls -ltha` | List files, including hidden entries and readable sizes. | Record your result |
| 10 | `file /etc/hosts` | Identify a file's type. | Record your result |
| 11 | `stat /etc/hosts` | Inspect file metadata and permissions. | Record your result |
| 12 | `find "$HOME" -maxdepth 2 -type f` | Find example files under the home directory. | Record your result |
| 13 | `du -sh "$HOME"` | Measure the home directory's total size. | Record your result |
| 14 | `df -h` | Check filesystem capacity in readable units. | Record your result |
| 15 | `df -i` | Check inode usage. | Record your result |
| 16 | `lsblk` | List block devices and partitions. | Record your result |
| 17 | `mount` | Inspect mounted filesystems. | Record your result |
| 18 | `umask` | Display the default permission mask. | Record your result |
| 19 | `groups` | List groups for the current user. | Record your result |
| 20 | `getent passwd ubuntu` | Look up the common Ubuntu EC2 account. | Record your result; username may differ |

## 3. Inspect processes, memory, services, and logs

| # | Command | Purpose | Lab observation |
|---:|---|---|---|
| 21 | `ps aux --sort=-%cpu` | Find processes with the highest CPU usage. | Record your result |
| 22 | `top -b -n 1` | Capture a one-time process and resource snapshot. | Record your result |
| 23 | `pgrep -a sshd` | Find SSH daemon processes. | Record your result |
| 24 | `systemctl is-active ssh` | Check whether the SSH service is active. | Record your result |
| 25 | `systemctl status ssh --no-pager` | Inspect SSH service state and recent status. | Record your result |
| 26 | `journalctl -u ssh -n 20 --no-pager` | Review recent SSH service logs. | Record your result |
| 27 | `systemctl --failed` | List failed systemd units. | Record your result |
| 28 | `sudo journalctl -p err -n 20 --no-pager` | Review recent system journal errors. | Record your result |
| 29 | `free -h` | Inspect RAM and swap usage. | Record your result |
| 30 | `vmstat 1 3` | Sample CPU, memory, and system activity. | Record your result |

## 4. Diagnose networking and firewall access

| # | Command | Purpose | Lab observation |
|---:|---|---|---|
| 31 | `ip -br addr` | Summarise network interfaces and IP addresses. | Record your result |
| 32 | `ip route` | Inspect the routing table and default route. | Record your result |
| 33 | `hostname -I` | Display assigned IP addresses. | Record your result |
| 34 | `ss -s` | Summarise socket statistics. | Record your result |
| 35 | `sudo ss -tulpn` | Inspect listening TCP/UDP sockets and processes. | Record your result |
| 36 | `ping -c 4 1.1.1.1` | Test basic IP connectivity; ICMP may be blocked. | Record your result |
| 37 | `getent hosts example.com` | Test name resolution using the system resolver. | Record your result |
| 38 | `dig +short example.com` | Query DNS records; requires `dnsutils`. | Record your result |
| 39 | `curl -I --max-time 10 https://example.com` | Test HTTPS reachability and inspect response headers. | Record your result |
| 40 | `nc -vz 127.0.0.1 22` | Test local TCP access to SSH; requires netcat. | Record your result |
| 41 | `sudo ufw status verbose` | Check UFW state, defaults, and active rules. | Record your result |
| 42 | `sudo ufw status numbered` | Display numbered UFW rules for review. | Record your result |

## 5. Inspect packages and command-line tooling

| # | Command | Purpose | Lab observation |
|---:|---|---|---|
| 43 | `apt list --upgradable` | List packages with available upgrades. | Record your result |
| 44 | `dpkg -l openssh-server ufw` | Check whether SSH server and UFW packages are installed. | Record your result |
| 45 | `bash --version` | Display the installed Bash version. | Record your result |
| 46 | `command -v ssh` | Locate the SSH client executable. | Record your result |
| 47 | `ssh -V` | Display the SSH client version. | Record your result |
| 48 | `curl --version` | Display the curl version and build information. | Record your result |
| 49 | `sudo -l` | Review commands permitted through sudo. | Record your result; access may be restricted |
| 50 | `history` | Review recent shell history in an interactive session. | Record your result |

## Record evidence before completion

For each command note the **actual output**, what it confirms, and any unexpected result. If a command is unavailable, record the missing dependency or install it only when needed for the lab. Review findings before changing the instance.

For the main lab, verify SSH access from a second terminal after configuring UFW. Keep AWS Security Group SSH access restricted to a trusted source IP. Treat ICMP or external HTTPS failures as diagnostic evidence—not automatically as proof of a broken server.

**Related notes:** [SSH setup](ssh-setup.md) · [UFW firewall](ufw-firewall.md) · [Troubleshooting workflow](troubleshooting.md)

**Skills covered:** Linux administration · Cloud infrastructure operations · AWS EC2 · Bash · systemd service management · SSH key-based authentication · UFW firewall · TCP/IP · DNS diagnostics · process management · disk and memory monitoring · log analysis · operational troubleshooting.
