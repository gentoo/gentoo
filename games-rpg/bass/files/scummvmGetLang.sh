tmplang="$LANG"
test "$LC_MESSAGES" != "" && tmplang="$LC_MESSAGES"
test "$LC_ALL"      != "" && tmplang="$LC_ALL"
test "$LANGUAGE"    != "" && tmplang="$LANGUAGE"

lang=`echo $tmplang|cut -d "_" -f 1`

case $lang in
  en)
    lang=gb
    echo $tmplang | grep en_US &>/dev/null && lang=en
  ;;
  de|fr|it|pt|es|se)
  ;;
  *)
    lang=gb
  ;;
esac
echo $lang
