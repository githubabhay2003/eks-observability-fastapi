# EKS Observability Platform with Prometheus, Grafana, and FastAPI

A fully automated, rebuild-safe Kubernetes observability platform on AWS EKS using Terraform and Helm, featuring a FastAPI application instrumented with Prometheus metrics, alerting via Alertmanager, and visualization through Grafana.

![AWS](https://img.shields.io/badge/AWS-EKS-orange)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.29-blue)
![Helm](https://img.shields.io/badge/Helm-Charts-blueviolet)
![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-red)
![Grafana](https://img.shields.io/badge/Grafana-Visualization-orange)
![Status](https://img.shields.io/badge/Status-Production--Ready-green)

- [Overview](#overview)
- [Skills Demonstrated](#skills-demonstrated)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Setup and Deployment](#setup-and-deployment)
- [CI/CD Pipeline Explanation](#cicd-pipeline-explanation)
- [Verification Steps](#verification-steps)
- [Screenshots](#screenshots)
- [Challenges and Learnings](#challenges-and-learnings)
- [Future Improvements](#future-improvements)
- [Repository Structure](#repository-structure)
- [Contributing Guidelines](#contributing-guidelines)
- [License & Author](#license--author)

## Overview

This project demonstrates a production-style, fully reproducible Kubernetes observability platform on AWS EKS, built using Terraform and Helm as the single sources of truth.

The platform provisions an Amazon EKS cluster inside a custom VPC, deploys a containerized FastAPI application instrumented with Prometheus metrics, and installs a Kubernetes-native monitoring stack using kube-prometheus-stack.

**Key characteristics of the project:**

* **End-to-end automation:** Infrastructure, cluster access, namespaces, applications, monitoring, and alerting are all declaratively managed.
* **Rebuild-safe:** Running `terraform destroy` followed by `terraform apply` restores the entire platform without manual intervention.
* **Real-world observability:** Metrics scraping, dashboards, and alerts are implemented using industry-standard tools and patterns.
* **Interview-ready design:** Clear separation of concerns, least-privilege IAM, and Kubernetes-native primitives.

**The project is structured in phases:**

* **Phase 1:** Focuses on infrastructure, EKS provisioning, RBAC, and application deployment.
* **Phase 2:** Adds Kubernetes-native observability with Prometheus, Grafana, Alertmanager, dashboards, and alert rules.

This repository is intentionally designed to reflect how observability platforms are built and managed in real production environments.

## Skills Demonstrated

This project demonstrates practical, production-oriented skills across cloud infrastructure, Kubernetes operations, observability, and automation.

### Cloud & Infrastructure
* **Designing and provisioning** a custom AWS VPC with public and private subnets.
* **Deploying and managing** Amazon EKS with managed node groups.
* **Implementing least-privilege IAM roles** and policies for EKS, nodes, and bastion access.
* **Using a bastion host** for secure cluster administration.

### Infrastructure as Code (IaC)
* **End-to-end infrastructure provisioning** using Terraform.
* **Managing Kubernetes resources declaratively** via:
  * `helm_release`
  * `kubernetes_manifest`
  * `kubernetes_namespace_v1`
* **Handling real-world Terraform issues:**
  * Namespace lifecycle and termination.
  * Resource ordering and dependencies.
  * Safe rebuilds using `terraform destroy` and `terraform apply`.

### Kubernetes
* **Namespace isolation** (observability, monitoring).
* **Deploying and managing applications** via Helm.
* **Service discovery** using Kubernetes labels and selectors.
* **Using Kubernetes-native CRDs:**
  * `ServiceMonitor`
  * `PrometheusRule`

### Observability & Monitoring
* **Deploying kube-prometheus-stack** (Prometheus, Grafana, Alertmanager).
* **Automatic metrics discovery** using `ServiceMonitor`.
* **Designing Golden Signals monitoring:**
  * Latency
  * Traffic
  * Errors
  * Saturation
* **Writing PromQL-based alert rules.**
* **Validating alerts** through controlled failure scenarios.
* **Grafana dashboard provisioning** using JSON files (no manual UI creation).

### Operations & Debugging
* **Diagnosing Helm and Kubernetes failures:**
  * Admission webhook issues.
  * Namespace termination conflicts.
  * CRD readiness timing.
* **Reading and interpreting logs** from:
  * Prometheus
  * Grafana
  * Alertmanager
* **Understanding automation boundaries** (what to automate vs. what to keep manual for security/access).

### Professional Engineering Practices
* **Clean separation of concerns** between infrastructure, platform, and application layers.
* **Rebuild-safe, version-controlled** observability setup.
* **Clear operational documentation** and verification steps.
* **Production-aligned design decisions** suitable for technical interviews and real-world teams.

## Architecture

### Visual Overview
> [!IMPORTANT]
> [Architecture diagram to be added here – showing AWS VPC, EKS, namespaces, and observability stack]

### High-Level Architecture Overview
This project implements a Kubernetes-native observability platform on AWS using Amazon EKS. The architecture is designed to be secure, modular, and rebuild-safe using Infrastructure as Code (Terraform).

### Architecture Components

#### 1. AWS Infrastructure
* **VPC (Custom):** * **Public subnets:** Hosts the **Bastion host** and **NAT Gateway**.
    * **Private subnets:** Hosts **EKS worker nodes**, application pods, and the monitoring stack.
* **Bastion Host (EC2):** Secure administrative access point used to run `kubectl`, `helm`, and operational commands. No direct public access is allowed to EKS nodes.
* **Amazon EKS:** Managed Kubernetes control plane with an Ubuntu-based **Managed Node Group** (`m7i-flex.large`).

#### 2. Kubernetes Namespaces
* **`observability`**: Contains the **FastAPI application**, its Service, and metrics endpoints.
* **`monitoring`**: Contains the **kube-prometheus-stack** (Prometheus, Grafana, Alertmanager) and CRDs like `ServiceMonitor`.

#### 3. Observability Stack
* **Prometheus:** Scrapes cluster and application metrics; automatically discovers targets via `ServiceMonitor`.
* **Grafana:** Visualizes metrics using **version-controlled JSON dashboards** (no manual UI setup required).
* **Alertmanager:** Evaluates `PrometheusRule` conditions and manages alert states.

### Traffic & Data Flow
1. **FastAPI** exposes a `/metrics` endpoint.
2. **ServiceMonitor** (in the `monitoring` namespace) discovers the FastAPI service.
3. **Prometheus** scrapes metrics at defined intervals.
4. **Grafana** queries Prometheus to populate real-time dashboards.
5. **PrometheusRule** evaluates alert conditions; if triggered, **Alertmanager** handles the notification state.

### Design Principles
* **Kubernetes-native:** No external agents; everything runs within the cluster.
* **Declarative:** Entire stack is defined in code.
* **Separation of Concerns:** Clear boundaries between application and platform layers.
* **Rebuild-safe:** Guaranteed consistency across repeated `terraform destroy` and `terraform apply` cycles.

## Tech Stack

The project uses a modern, production-grade cloud-native stack focused on automation, observability, and reliability.

| Category | Tool / Service |
| :--- | :--- |
| **Cloud Provider** | AWS (Amazon Web Services) |
| **Container Orchestration** | Amazon EKS (Elastic Kubernetes Service) |
| **Infrastructure as Code** | Terraform |
| **Package Management** | Helm |
| **Kubernetes Management** | `kubectl` |
| **Application Framework** | FastAPI (Python) |
| **Monitoring** | Prometheus |
| **Visualization** | Grafana |
| **Alerting** | Alertmanager |
| **Metrics Discovery** | ServiceMonitor (Prometheus Operator) |
| **Alert Rules** | PrometheusRule |
| **Container Registry** | Amazon ECR |
| **Compute** | EC2 (Bastion Host, EKS Nodes) |
| **Networking** | VPC, Subnets, NAT Gateway |
| **Authentication** | AWS IAM, `aws-auth` ConfigMap |
| **Operating System** | Amazon Linux (Bastion), Ubuntu (EKS Nodes) |

