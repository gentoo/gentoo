#%PAM-1.0

account required        pam_unix.so

auth    required        pam_unix.so

session required        pam_limits.so
