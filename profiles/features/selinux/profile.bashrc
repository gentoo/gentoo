# SELinux-aware progams write to entries here
SANDBOX_WRITE="${SANDBOX_WRITE}:/selinux/:/sys/fs/selinux/"

# for setfscreatecon
SANDBOX_WRITE="${SANDBOX_WRITE}:/proc/self/"
