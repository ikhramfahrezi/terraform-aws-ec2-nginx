# Automated AWS EC2 & Nginx Deployment with Terraform

Repository ini berisi kode **Infrastructure as Code (IaC)** menggunakan **Terraform** untuk melakukan penyediaan (*provisioning*) otomatis server virtual AWS EC2 yang menjalankan **Ubuntu Linux** dan web server **Nginx**.

## 📌 Arsitektur & Fitur

- **Dynamic AMI Lookup:** Otomatis mencari ID AMI Ubuntu 24.04 LTS terbaru di region AWS yang dipilih.
- **Automated Security Group:** Konfigurasi *firewall* otomatis untuk membuka akses **SSH (Port 22)** dan **HTTP (Port 80)**.
- **User Data Scripting:** Pemasangan dan konfigurasi otomatis Nginx Web Server saat server pertama kali dinyalakan.
- **Clean Outputs:** Menampilkan IP Publik dan URL website secara langsung di terminal setelah *deployment* selesai.

---

## 🛠️ Prasyarat (Prerequisites)

Sebelum menjalankan kode ini, pastikan kamu sudah menyiapkan:

1. **Terraform** (versi `>= 1.0.0`) terinstal di laptop.
2. **AWS Account** aktif dengan akses *Free Tier*.
3. **AWS Access Key & Secret Key** yang sudah diatur sebagai *environment variables* di terminal kamu:

```bash
# Linux / macOS
export AWS_ACCESS_KEY_ID="KUNCI_ACCESS_KAMU"
export AWS_SECRET_ACCESS_KEY="KUNCI_SECRET_KAMU"
export AWS_DEFAULT_REGION="us-east-1"

# Windows (PowerShell)
$env:AWS_ACCESS_KEY_ID="KUNCI_ACCESS_KAMU"
$env:AWS_SECRET_ACCESS_KEY="KUNCI_SECRET_KAMU"
$env:AWS_DEFAULT_REGION="us-east-1"

🚀 Cara Penggunaan
1. Clone repository ini:
git clone https://github.com/ikhramfahrezi/terraform-aws-ec2-nginx.git
cd terraform-aws-ec2-nginx

2. Inisialisasi Terraform (Mengunduh provider AWS):
terraform init
Lihat simulasi perubahan (Preview):

3. Lihat simulasi perubahan (Preview):
terraform plan
Eksekusi deployment ke AWS:

4. Eksekusi deployment ke AWS:
terraform apply
Ketik yes saat konfirmasi muncul. Setelah selesai, terminal akan menampilkan Public IP dan URL Website.

5. Akses Website:
Buka URL http://<PUBLIC_IP> di browser (pastikan menggunakan http://).

🧹 Hapus Infrastruktur
Untuk menghapus seluruh resource yang telah dibuat di AWS agar tidak memakan kuota tagihan:

Bash
terraform destroy
Ketik yes saat diminta konfirmasi.

📂 Struktur File
Plaintext
.
├── main.tf        # Konfigurasi utama Terraform (Provider, Security Group, EC2, Output)
├── .gitignore     # Mencegah state file dan kredensial ter-upload ke Git
└── README.md      # Dokumentasi project
