#! /bin/sh

main() {
    local NFTABLES_SAVE=${2:-'/var/lib/nftables/rules-save'}
    local retval
    case "$1" in
        "clear")
            if ! use_legacy; then
                nft flush ruleset
            else
                clear_legacy
            fi
            retval=$?
        ;;
        "list")
            if ! use_legacy; then
                nft list ruleset
            else
                list_legacy
            fi
            retval=$?
        ;;
        "load")
            nft -f ${NFTABLES_SAVE}
            retval=$?
        ;;
        "store")
            local tmp_save="${NFTABLES_SAVE}.tmp"
            if ! use_legacy; then
                nft list ruleset > ${tmp_save}
            else
                save_legacy ${tmp_save}
            fi
            retval=$?
            if [ ${retval} ]; then
                mv ${tmp_save} ${NFTABLES_SAVE}
            fi
        ;;
    esac
    return ${retval}
}

clear_legacy() {
    local l3f line table chain first_line

    first_line=1
    if manualwalk; then
        for l3f in $(getfamilies); do
            nft list tables ${l3f} | while read line; do
                table=$(echo ${line} | sed "s/table[ \t]*//")
                deletetable ${l3f} ${table}
            done
        done
    else
        nft list tables | while read line; do
            l3f=$(echo ${line} | cut -d ' ' -f2)
            table=$(echo ${line} | cut -d ' ' -f3)
            deletetable ${l3f} ${table}
        done
    fi
}

list_legacy() {
    local l3f

    if manualwalk; then
        for l3f in $(getfamilies); do
            nft list tables ${l3f} | while read line; do
                line=$(echo ${line} | sed "s/table/table ${l3f}/")
                echo "$(nft list ${line})"
            done
        done
    else
        nft list tables | while read line; do
            echo "$(nft list ${line})"
        done
    fi
}

save_legacy() {
    tmp_save=$1
    touch "${tmp_save}"
    if manualwalk; then
        for l3f in $(getfamilies); do
            nft list tables ${l3f} | while read line; do
                line=$(echo ${line} | sed "s/table/table ${l3f}/")
                nft ${SAVE_OPTIONS} list ${line} >> ${tmp_save}
            done
        done
    else
        nft list tables | while read line; do
            nft ${SAVE_OPTIONS} list ${line} >> "${tmp_save}"
        done
    fi
}

use_legacy() {
    local major_ver minor_ver

    major_ver=$(uname -r | cut -d '.' -f1)
    minor_ver=$(uname -r | cut -d '.' -f2)

    [[ $major_ver -ge 4 || $major_ver -eq 3 && $minor_ver -ge 18 ]] && return 1
    return 0
}

CHECK_TABLE_NAME="GENTOO_CHECK_TABLE"

getfamilies() {
    local l3f families

    for l3f in ip arp ip6 bridge inet; do
        if nft create table ${l3f} ${CHECK_TABLE_NAME} > /dev/null 2>&1; then
            families="${families}${l3f} "
            nft delete table ${l3f} ${CHECK_TABLE_NAME}
        fi
    done
    echo ${families}
}

manualwalk() {
    local result l3f=`getfamilies | cut -d ' ' -f1`

    nft create table ${l3f} ${CHECK_TABLE_NAME}
    nft list tables | read line
    if [ $(echo $line | wc -w) -lt 3 ]; then
        result=0
    fi
    result=1
    nft delete table ${l3f} ${CHECK_TABLE_NAME}

    return $result
}

deletetable() {
    # family is $1
    # table name is $2
    nft flush table $1 $2
    nft list table $1 $2 | while read l; do
        chain=$(echo $l | grep -o 'chain [^[:space:]]\+' | cut -d ' ' -f2)
        if [ -n "${chain}" ]; then
            nft flush chain $1 $2 ${chain}
            nft delete chain $1 $2 ${chain}
        fi
    done
    nft delete table $1 $2
}

main "$@"
exit $?
