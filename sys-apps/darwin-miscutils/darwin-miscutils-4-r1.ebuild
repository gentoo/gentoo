# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit toolchain-funcs

MISC_VER=18
SHELL_VER=81
DEV_VER=39

DESCRIPTION="Miscellaneous commands used on Darwin/Mac OS X systems, Tiger"
HOMEPAGE="http://www.opensource.apple.com/"
SRC_URI="http://www.opensource.apple.com/darwinsource/tarballs/other/misc_cmds-${MISC_VER}.tar.gz
	http://www.opensource.apple.com/darwinsource/tarballs/other/shell_cmds-${SHELL_VER}.tar.gz
	http://www.opensource.apple.com/darwinsource/tarballs/other/developer_cmds-${DEV_VER}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_compile() {
	local TS=${S}/misc_cmds-${MISC_VER}
	# tsort is provided by coreutils
	for t in cal leave lock units calendar; do
		cd "${TS}/${t}"
		echo "in ${TS}/${t}:"
		echo "$(tc-getCC) -o ${t}" *.c
		$(tc-getCC) -o ${t} *.c || die "failed to compile $t"
	done

	TS=${S}/shell_cmds-${SHELL_VER}
	# only pick those tools not provided by coreutils, findutils
	for t in \
		alias apply getopt hostname jot kill killall \
		lastcomm renice script shlock time whereis;
	do
		echo "in ${TS}/${t}:"
		echo "$(tc-getCC) -o ${t} ${t}.c"
		cd "${TS}/${t}"
		$(tc-getCC) -o ${t} ${t}.c || die "failed to compile $t"
	done
	cd "${TS}/su"
	echo "in ${TS}/su:"
	echo "$(tc-getCC) -lpam -o su su.c"
	$(tc-getCC) -lpam -o su su.c || die "failed to compile su"
	cd "${TS}/w"
	echo "in ${TS}/w:"
	echo "$(tc-getCC) -DSUCKAGE -lresolv -o w w.c pr_time.c proc_compare.c"
	$(tc-getCC) -DSUCKAGE -lresolv -o w w.c pr_time.c proc_compare.c \
		|| die "failed to compile w"

	TS=${S}/developer_cmds-${DEV_VER}
	# only pick those tools that do not conflict (no ctags and indent)
	# do not install lorder, mkdep and vgrind as they are a non-prefix-aware
	# shell scripts
	# don't install rpcgen, as it is heavily related to the OS it runs
	# on (and this is the Tiger version)
	for t in asa error hexdump unifdef what ; do
		echo "in ${TS}/${t}:"
		echo "$(tc-getCC) -o ${t}" *.c
		cd "${TS}/${t}"
		sed -i -e '/^__FBSDID/d' *.c
		$(tc-getCC) -o ${t} *.c || die "failed to compile $t"
	done
}

src_install() {
	mkdir -p "${ED}"/bin
	mkdir -p "${ED}"/usr/bin

	local TS=${S}/misc_cmds-${MISC_VER}
	for t in cal leave lock units calendar ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		doman "${TS}/${t}/${t}.1"
	done

	TS=${S}/shell_cmds-${SHELL_VER}
	for t in \
		alias apply getopt jot killall lastcomm \
		renice script shlock su time w whereis;
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
	for t in asa error hexdump unifdef what ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		doman "${TS}/${t}/${t}.1"
	done
}
