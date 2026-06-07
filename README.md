#  Pinnacle Health Clinic - IT Portfolio

A fully documented IT operations and cybersecurity portfolio built 
around a simulated healthcare environment.

## Environment Overview

**Pinnacle Health Clinic** is a simulated primary care office with 
18 employees across four departments, built to demonstrate real-world 
IT skills in a HIPAA-relevant context.

### Lab Stack
| Component | Technology |
|---|---|
| Domain Controller | Windows Server 2022 - pinnacle.local |
| Active Directory | 17 users, 5 security groups, 15 OUs |
| Group Policy | 4 department GPOs |
| Client Workstation | Windows 10/11 - PC-CLIN01 |
| SIEM | Wazuh |
| Attack Platform | Kali Linux |
| Network Simulation | Cisco Packet Tracer |

### Network Design
| VLAN | Department | Subnet |
|---|---|---|
| 10 | Clinical | 192.168.10.0/24 |
| 20 | Admin | 192.168.20.0/24 |
| 30 | Billing | 192.168.30.0/24 |
| 40 | IT / Servers | 192.168.40.0/24 |
| 99 | Guest WiFi | 192.168.99.0/24 |

---

## Simulations

### AD Operations - VirtualBox
| Ticket | Simulation | Status |
|---|---|---|
| PHC-2026-001 | New Hire Onboarding - Dr. James Carter |  Complete |
| PHC-2026-002 | Password Reset - Tom Ellis |  Complete |
| PHC-2026-003 | Employee Offboarding - Paula Scott |  Complete |
| PHC-2026-004 | Bulk Onboarding - 3 Admin Staff |  Complete |
| PHC-2026-005 | GPO Troubleshooting |  Complete |
| PHC-2026-006 | Delegation - Zoe Adams |  Complete |
| PHC-2026-007 | Workstation Reassignment |  Complete |


### Network Troubleshooting - Packet Tracer
| Simulation | Status |
|---|---|
| "I can't get to the internet" - DHCP/routing failure |  Complete |
| "My IP is 169.254.x.x" - APIPA diagnosis |  Complete |
| "Can't reach the shared drive" - inter-VLAN routing |  Pending |
| Guest WiFi reaching internal systems - VLAN isolation |  Pending |

### Cybersecurity - Wazuh + Kali
| Simulation | Status |
|---|---|
| Nmap reconnaissance - MITRE T1046 |  Pending |
| Brute force attack - MITRE T1110 |  Pending |
| Scheduled task persistence - MITRE T1053.005 |  Pending |
| Full incident response write-up |  Pending |


---

*Built for professional development and portfolio documentation.*
