# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

# from macOS 10.13
MISC_VER=34
SHELL_VER=203
# from DT 8.2.1
DEV_VER=63
# from 10.7.4
MD_VER=147 # adv_cmds-148 in 10.8 has no md, bug #428530

DESCRIPTION="Miscellaneous commands used on macOS, High Sierra 10.13"
HOMEPAGE="https://www.opensource.apple.com/"
SRC_URI="https://opensource.apple.com/tarballs/misc_cmds/misc_cmds-${MISC_VER}.tar.gz
	https://opensource.apple.com/tarballs/shell_cmds/shell_cmds-${SHELL_VER}.tar.gz
	https://opensource.apple.com/tarballs/developer_cmds/developer_cmds-${DEV_VER}.tar.gz
	https://opensource.apple.com/source/adv_cmds/adv_cmds-${MD_VER}/md/md.c -> adv_cmds-md-${MD_VER}.c
	https://opensource.apple.com/source/adv_cmds/adv_cmds-${MD_VER}/md/md.1 -> adv_cmds-md-${MD_VER}.1
	https://642666.bugs.gentoo.org/attachment.cgi?id=511988 -> adv_cmds-md-${MD_VER}-compile.patch"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc-macos ~x64-macos"
IUSE=""

# for ncal
DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	cd "${S}"/shell_cmds-${SHELL_VER} || die
	eapply "${FILESDIR}"/${PN}-6-w64.patch

	mkdir -p "${S}"/adv_cmds-${MD_VER}/md || die
	cd "${S}"/adv_cmds-${MD_VER} || die
	cp "${DISTDIR}"/adv_cmds-md-${MD_VER}.c md/md.c || die
	cp "${DISTDIR}"/adv_cmds-md-${MD_VER}.1 md/md.1 || die
	eapply "${DISTDIR}"/adv_cmds-md-${MD_VER}-compile.patch

	cd "${S}"
	eapply_user
}

src_compile() {
	local flags=(
		${CFLAGS}
		-I.
		-D__FBSDID=__RCSID
		-Du_int=uint32_t
		-include stdint.h
	)

	v() {
		echo "$*"
		$@
	}

	local TS=${S}/misc_cmds-${MISC_VER}
	# tsort is provided by coreutils
	for t in leave units calendar; do
		cd "${TS}/${t}"
		echo "in ${TS}/${t}:"
		v $(tc-getCC) ${flags[@]} -o ${t} ${LDFLAGS} *.c || die
	done
	# compile cal separately
	cd "${TS}/ncal"
	echo "in ${TS}/ncal:"
	v $(tc-getCC) ${flags[@]} -c calendar.c || die
	v $(tc-getCC) ${flags[@]} -c easter.c || die
	v $(tc-getCC) ${flags[@]} -c ncal.c || die
	v $(tc-getCC) -o cal ${LDFLAGS} -lncurses calendar.o easter.o ncal.o || die

	TS=${S}/shell_cmds-${SHELL_VER}
	# only pick those tools not provided by coreutils, findutils
	for t in \
		apply getopt hexdump hostname jot kill killall \
		lastcomm renice script shlock time whereis;
	do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}"
		v $(tc-getCC) ${flags[@]} -o ${t} ${LDFLAGS} *.c || die
	done
	cd "${TS}/w"
	sed -i -e '/#include <libutil.h>/d' w.c || die
	echo "in ${TS}/w:"
	v $(tc-getCC) ${flags[@]} -DHAVE_UTMPX=1 ${LDFLAGS} -lresolv -o w *.c || die

	TS=${S}/developer_cmds-${DEV_VER}
	# only pick those tools that do not conflict (no ctags and indent)
	# do not install lorder, mkdep and vgrind as they are a non-prefix-aware
	# shell scripts
	# don't install rpcgen, as it is heavily related to the OS it runs
	# on (and this is the High Sierra version)
	for t in asa unifdef what ; do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}" || die
		v $(tc-getCC) ${flags[@]} -o ${t} ${LDFLAGS} *.c || die
	done

	# provide this one for gcc-apple
	TS=${S}/adv_cmds-${MD_VER}
	for t in md ; do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}" || die
		v $(tc-getCC) ${flags[@]} -o ${t} ${LDFLAGS} *.c || die
	done
}

src_install() {
	mkdir -p "${ED}"/{,usr/}bin

	local TS=${S}/misc_cmds-${MISC_VER}
	for t in leave units calendar ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		doman "${TS}/${t}/${t}.1"
	done
	# copy cal separately
	cp "${TS}/ncal/cal" "${ED}"/usr/bin/ncal
	dosym ncal /usr/bin/cal
	doman "${TS}/ncal/ncal.1"
	dosym ncal.1 /usr/share/man/man1/cal.1

	TS=${S}/shell_cmds-${SHELL_VER}
	for t in \
		apply getopt hexdump hostname jot killall lastcomm \
		renice script shlock time w whereis;
	do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		[[ -f "${TS}/${t}/${t}.1" ]] && doman "${TS}/${t}/${t}.1"
		[[ -f "${TS}/${t}/${t}.8" ]] && doman "${TS}/${t}/${t}.8"
	done
	cp "${TS}/w/w" "${ED}"/usr/bin/uptime
	doman "${TS}/w/uptime.1"
	for t in hostname kill; do
		cp "${TS}/${t}/${t}" "${ED}"/bin/
		doman "${TS}/${t}/${t}.1"
	done

	TS=${S}/developer_cmds-${DEV_VER}
	for t in asa unifdef what ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		doman "${TS}/${t}/${t}.1"
	done

	TS=${S}/adv_cmds-${MD_VER}
	for t in md ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		doman "${TS}/${t}/${t}.1"
	done
}
