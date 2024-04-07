# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

MISC_VER=23
SHELL_VER=118
DEV_VER=49

DESCRIPTION="Miscellaneous commands used on Darwin/Mac OS X systems, Leopard"
HOMEPAGE="
	https://www.opensource.apple.com/
	https://github.com/apple-oss-distributions"
SRC_URI="
	https://opensource.apple.com/tarballs/misc_cmds/misc_cmds-${MISC_VER}.tar.gz
	https://opensource.apple.com/tarballs/shell_cmds/shell_cmds-${SHELL_VER}.tar.gz
	https://opensource.apple.com/tarballs/developer_cmds/developer_cmds-${DEV_VER}.tar.gz"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64-macos ~ppc-macos ~x64-macos"

src_prepare() {
	eapply -p0 "${FILESDIR}"/${PN}-5-w.patch
	eapply -p0 "${FILESDIR}"/${PN}-5-stdlib.patch
	eapply -p0 "${FILESDIR}"/${PN}-6-w64.patch
	cd "${S}"/developer_cmds-${DEV_VER} || die
	eapply "${FILESDIR}"/${PN}-5-error.patch
	# deal with OSX Lion and above
	sed -i -e 's/getline/ugetline/g' unifdef/unifdef.c || die

	eapply_user
}

src_compile() {
	local TS="${S}/misc_cmds-${MISC_VER}"
	# tsort is provided by corepatch
	local t
	for t in leave units calendar; do
		cd "${TS}/${t}" || die
		echo "in ${TS}/${t}:"
		edo $(tc-getCC) -o ${t} *.c
	done
	# compile cal separately
	cd "${TS}/ncal" || die
	echo "in ${TS}/ncal:"
	local flags
	flags[0]=-I.
	flags[1]=-D__FBSDID=__RCSID
	flags[2]=-Wsystem-headers
	edo $(tc-getCC) ${flags[@]} -c calendar.c
	edo $(tc-getCC) ${flags[@]} -c easter.c
	edo $(tc-getCC) ${flags[@]} -c ncal.c
	edo $(tc-getCC) ${flags[@]} -o cal calendar.o easter.o ncal.o

	TS="${S}/shell_cmds-${SHELL_VER}"
	# only pick those tools not provided by corepatch, findutils
	for t in \
		alias apply getopt hostname jot kill \
		lastcomm renice shlock time whereis;
	do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}" || die
		edo $(tc-getCC) -o ${t} ${t}.c
	done
	# script and killall need additonal flags
	for t in \
		killall script
	do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}" || die
		edo $(tc-getCC) -D__FBSDID=__RCSID -o ${t} ${t}.c
	done
	cd "${TS}/w" || die
	echo "in ${TS}/w:"
	edo $(tc-getCC) -DHAVE_UTMPX=1 -lresolv -o w w.c pr_time.c proc_compare.c

	TS="${S}/developer_cmds-${DEV_VER}"
	# only pick those tools that do not conflict (no ctags and indent)
	# do not install lorder, mkdep and vgrind as they are a non-prefix-aware
	# shell scripts
	# don't install rpcgen, as it is heavily related to the OS it runs
	# on (and this is the Leopard version)
	for t in asa error hexdump unifdef what ; do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}" || die
		sed -i -e '/^__FBSDID/d' *.c || die
		edo $(tc-getCC) -o ${t} *.c
	done
}

src_install() {
	mkdir -p "${ED}"/bin || die
	mkdir -p "${ED}"/usr/bin || die

	local TS="${S}/misc_cmds-${MISC_VER}"
	local t
	for t in leave units calendar ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/ || die
		doman "${TS}/${t}/${t}.1"
	done
	# copy cal separately
	cp "${TS}/ncal/cal" "${ED}"/usr/bin/ || die
	dosym cal /usr/bin/ncal
	doman "${TS}/ncal/ncal.1"
	dosym ncal.1 /usr/share/man/man1/cal.1

	TS="${S}/shell_cmds-${SHELL_VER}"
	for t in \
		alias apply getopt jot killall lastcomm \
		renice script shlock su time w whereis;
	do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/ || die
		[[ -f "${TS}/${t}/${t}.1" ]] && doman "${TS}/${t}/${t}.1"
		[[ -f "${TS}/${t}/${t}.8" ]] && doman "${TS}/${t}/${t}.8"
	done
	cp "${TS}/w/w" "${ED}"/usr/bin/uptime || die
	doman "${TS}/w/uptime.1"
	for t in hostname kill; do
		cp "${TS}/${t}/${t}" "${ED}"/bin/ || die
		doman "${TS}/${t}/${t}.1"
	done

	TS="${S}/developer_cmds-${DEV_VER}"
	for t in asa error hexdump unifdef what ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/ || die
		doman "${TS}/${t}/${t}.1"
	done
}
