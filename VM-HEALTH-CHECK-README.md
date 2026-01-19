# VM Health Check Script for OKE

A bash script designed to monitor the health of virtual machines hosted in Oracle Kubernetes Engine (OKE) by checking critical system resources: CPU usage, memory usage, and disk space.

## 📋 Overview

This script provides automated health monitoring for VMs running in OKE environments. It evaluates three key performance metrics and determines the overall health status of the system based on configurable thresholds.

## 🎯 Features

- **CPU Usage Monitoring**: Tracks current CPU utilization
- **Memory Usage Monitoring**: Monitors RAM consumption
- **Disk Space Monitoring**: Checks root partition disk usage
- **Health Status**: Returns `healthy` or `unhealthy` based on resource usage
- **Detailed Reporting**: Provides breakdown of each metric with the `--explain` option
- **Configurable Threshold**: Default threshold set at 70%

## 📊 Health Check Logic

The script evaluates the VM health based on the following criteria:

- **Healthy**: All three parameters (CPU, Memory, Disk) are **below or equal to 70%**
- **Unhealthy**: Any one or more parameters are **above 70%**

## 🚀 Usage

### Basic Health Check

Run the script without any arguments to perform a health check:

```bash
./vm-health-check.sh
```

**Output:**
- `healthy` - if all metrics are within acceptable ranges (≤70%)
- `unhealthy` - if any metric exceeds the threshold (>70%)

**Exit Codes:**
- `0` - System is healthy
- `1` - System is unhealthy

### Detailed Explanation

Use the `--explain` flag to see detailed metrics:

```bash
./vm-health-check.sh --explain
```

**Example Output:**
```
=== VM Health Metrics ===
CPU Usage:    45%
Memory Usage: 62%
Disk Usage:   38%
=========================

Threshold: 70%

✅ CPU is healthy (45% <= 70%)
✅ Memory is healthy (62% <= 70%)
✅ Disk is healthy (38% <= 70%)
```

### Help Information

Display usage information:

```bash
./vm-health-check.sh --help
```

## 🔧 Installation

1. Clone this repository:
```bash
git clone https://github.com/AnjaliRajan24/AnjaliRajan24.git
cd AnjaliRajan24
```

2. Make the script executable:
```bash
chmod +x vm-health-check.sh
```

3. Run the script:
```bash
./vm-health-check.sh
```

## 💡 Use Cases

### Manual Monitoring
```bash
# Quick health check
./vm-health-check.sh

# Detailed analysis
./vm-health-check.sh --explain
```

### Automated Monitoring with Cron
Add to crontab for regular health checks:

```bash
# Check health every 5 minutes and log results
*/5 * * * * /path/to/vm-health-check.sh >> /var/log/vm-health.log 2>&1

# Send alert when unhealthy
*/5 * * * * /path/to/vm-health-check.sh || echo "VM is unhealthy!" | mail -s "Health Alert" admin@example.com
```

### Kubernetes Health Probe
Use as a liveness or readiness probe in Kubernetes:

```yaml
livenessProbe:
  exec:
    command:
    - /bin/bash
    - /path/to/vm-health-check.sh
  initialDelaySeconds: 30
  periodSeconds: 60
```

### Integration with Monitoring Systems
```bash
# Check status and send to monitoring system
STATUS=$(./vm-health-check.sh)
if [ "$STATUS" == "unhealthy" ]; then
    # Trigger alert in your monitoring system
    curl -X POST https://monitoring.example.com/alert -d "status=unhealthy"
fi
```

## 📝 Requirements

- **Operating System**: Linux (tested on Ubuntu, Oracle Linux, CentOS)
- **Required Commands**: 
  - `top` - for CPU monitoring
  - `free` - for memory monitoring
  - `df` - for disk space monitoring
  - `awk`, `sed`, `grep` - for data processing

These utilities are typically pre-installed on most Linux distributions.

## ⚙️ Configuration

To modify the health threshold, edit the script and change the `THRESHOLD` variable:

```bash
# Default is 70%
THRESHOLD=70

# Change to 80% if needed
THRESHOLD=80
```

## 🐛 Troubleshooting

### Permission Denied
If you get a permission error, ensure the script is executable:
```bash
chmod +x vm-health-check.sh
```

### Command Not Found
Ensure required utilities are installed:
```bash
# For Debian/Ubuntu
apt-get update && apt-get install -y procps coreutils

# For RHEL/CentOS/Oracle Linux
yum install -y procps-ng coreutils
```

## 📄 License

This project is open source and available for use in OKE environments and other VM monitoring scenarios.

## 👤 Author

**Anjali Rajan**
- Platform Engineer at Oracle Health & AI
- Specialized in Kubernetes and Infrastructure Automation
- GitHub: [@AnjaliRajan24](https://github.com/AnjaliRajan24)
- LinkedIn: [anjali-rajan](https://linkedin.com/in/anjali-rajan)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## 📮 Support

If you encounter any issues or have questions, please open an issue on GitHub.

---

**Note**: This script is designed for use in OKE (Oracle Kubernetes Engine) environments but can be adapted for any Linux-based VM monitoring scenario.
