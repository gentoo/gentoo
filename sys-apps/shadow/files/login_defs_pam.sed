/^FAILLOG_ENAB/b comment
/^LASTLOG_ENAB/b comment
/^MAIL_CHECK_ENAB/b comment
/^OBSCURE_CHECKS_ENAB/b comment
/^PORTTIME_CHECKS_ENAB/b comment
/^QUOTAS_ENAB/b comment
/^MOTD_FILE/b comment
/^FTMP_FILE/b comment
/^NOLOGINS_FILE/b comment
/^ENV_HZ/b comment
/^PASS_MIN_LEN/b comment
/^SU_WHEEL_ONLY/b comment
/^CRACKLIB_DICTPATH/b comment
/^PASS_CHANGE_TRIES/b comment
/^PASS_ALWAYS_WARN/b comment
/^CHFN_AUTH/b comment
/^ENVIRON_FILE/b comment

b exit

: comment
  s:^:#:

: exit
