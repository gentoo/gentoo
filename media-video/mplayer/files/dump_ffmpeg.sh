#!/bin/sh

FFMPEG_DIR=ffmpeg
FFMPEG_MOVED_DIR=ffmpeg_removed
SYSTEM_FFMPEG_DIR=${EPREFIX}/usr/include

# Move directories

[ -d "${FFMPEG_DIR}" ] && mv "${FFMPEG_DIR}" "${FFMPEG_MOVED_DIR}"
[ -d "${FFMPEG_MOVED_DIR}" ] || exit 1
[ -d "${FFMPEG_DIR}" ] || mkdir "${FFMPEG_DIR}"

# Keep required files and check them

SANITIZED_REGEXP='^\#[[:space:]]*include.*\".*[.]h\"'
sanitize_includes() {
        sed -e "s/^\#[[:space:]]*include.*\"config[.]h\"/#include <config.h>/" \
                -e "s/^\#[[:space:]]*include.*\"\(libav.*\/.*[.]h\)\"/#include \<\1\>/" \
                -e "/${SANITIZED_REGEXP}/{s:\"\(.*\)\":\<${2}\/\1\>:}" ${1}
}

check_sanitized_includes() {
        grep -q "${SANITIZED_REGEXP}" $1
}

get_header_deps() {
        grep "^#[[:space:]]*include.*\<libav.*[.]h\>" ${1} | \
                sed -e "s/^#[[:space:]]*include.*\<\(libav.*[.]h\)\>/\1/" | \
                tr -d '<>' | tr '\n' ' '
}

check_header_deps() {
        for i ; do
                printf "Checking for the presence of ${i}...\n"
                if [ ! -f "${SYSTEM_FFMPEG_DIR}/${i}" -a ! -f "${FFMPEG_DIR}/${i}" ] ; then
                        printf "Header depends on ${i}\n"
                        printf "... but that file cannot be found, aborting\n"
                        exit 1
                fi
        done
}

move_file() {
        mydir="$(dirname $1)"
        printf "Moving and checking file: ${1}\n"
        [ -d "${FFMPEG_DIR}/${mydir}" ] || mkdir -p "${FFMPEG_DIR}/${mydir}"
        if [ ! -f "${FFMPEG_DIR}/${1}" ] ; then
                sanitize_includes "${FFMPEG_MOVED_DIR}/${1}" ${mydir} > "${FFMPEG_DIR}/${1}"
        fi
        if $(check_sanitized_includes "${FFMPEG_DIR}/${1}") ; then
                printf "Error, found non sanitized file in ffmpeg:\n"
                printf "${FFMPEG_DIR}/${1}\n"
                printf "Please report it at bugs.gentoo.org\n"
                exit 1
        fi
        if [ "${1%.h}" != "${1}" ] ; then
                mydeps=$(get_header_deps "${FFMPEG_DIR}/${1}")
                check_header_deps ${mydeps}
        fi
}

# HEADERS (order matters for the consistency checks: leaves come first)
FILES="libavutil/wchar_filename.h libavformat/os_support.h libavformat/internal.h libavutil/x86/asm.h"
# Files that are sed'ed but not compiled, used to check for availability of
# some codecs
FILES="${FILES} libavcodec/allcodecs.c libavformat/allformats.c libavfilter/allfilters.c"

for i in ${FILES} ; do
        move_file $i
done

rm -rf "${FFMPEG_MOVED_DIR}"

exit 0
