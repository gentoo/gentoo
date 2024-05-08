# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

# from DT 8.2.1
DEV_VER=63
# from 10.7.4
MD_VER=147 # adv_cmds-148 in 10.8 has no md, bug #428530

DESCRIPTION="Miscellaneous commands used on macOS, High Sierra 10.13"
HOMEPAGE="https://github.com/apple-oss-distributions"
SRC_URI="
	https://github.com/apple-oss-distributions/adv_cmds/blob/c8dbac91aa855b2d05282f45709b318f8bc3693d/md/md.1 \
		-> adv_cmds-md-${MD_VER}.1
	https://github.com/apple-oss-distributions/adv_cmds/blob/c8dbac91aa855b2d05282f45709b318f8bc3693d/md/md.c \
		-> adv_cmds-md-${MD_VER}.c
	https://642666.bugs.gentoo.org/attachment.cgi?id=511988 -> adv_cmds-md-${MD_VER}-compile.patch
	https://github.com/apple-oss-distributions/developer_cmds/archive/refs/tags/developer_cmds-${DEV_VER}.tar.gz"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64-macos ~ppc-macos ~x64-macos"

# for ncal
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	mkdir -p "${S}"/adv_cmds-${MD_VER}/md || die
	cd "${S}"/adv_cmds-${MD_VER} || die
	cp "${DISTDIR}"/adv_cmds-md-${MD_VER}.c md/md.c || die
	cp "${DISTDIR}"/adv_cmds-md-${MD_VER}.1 md/md.1 || die
	eapply "${FILESDIR}"/${PN}-12-md-modern-c.patch

	cd "${S}" || die
	eapply_user
}

src_compile() {
	local t
	local TS
	local flags=(
		${CFLAGS}
		-I.
		-D__FBSDID=__RCSID
		-Du_int=uint32_t
		-include stdint.h
	)

	# grobian 2024-04-07:
	# removed most tools here that are provided by host as well, but
	# newer versions, and they are in no way critical, but better
	# figured out by Apple (e.g. tools like w/uptime and hostname)
	# what's left here is developer tools that GCC interacts with
	# tools from developer_cmds we could probably loose, but they've
	# always worked up sofar, and they are needed on old targets
	# (Darwin9) most likely, so keep them.  md is just plain missing, so
	# keep it in any case

	TS="${S}/developer_cmds-developer_cmds-${DEV_VER}"  # new github archives
	# only pick those tools that do not conflict (no ctags and indent)
	# do not install lorder, mkdep and vgrind as they are a non-prefix-aware
	# shell scripts
	# don't install rpcgen, as it is heavily related to the OS it runs
	# on (and this is the High Sierra version)
	for t in asa unifdef what ; do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}" || die
		edo $(tc-getCC) ${flags[@]} -o ${t} ${LDFLAGS} *.c
	done

	# provide this one for gcc-apple
	TS="${S}/adv_cmds-${MD_VER}"
	for t in md ; do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}" || die
		edo $(tc-getCC) ${flags[@]} -o ${t} ${LDFLAGS} *.c
	done
}

src_install() {
	local t
	local TS
	mkdir -p "${ED}"/{,usr/}bin || die

	TS="${S}/developer_cmds-developer_cmds-${DEV_VER}"  # new github archives
	for t in asa unifdef what ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/ || die
		doman "${TS}/${t}/${t}.1"
	done

	TS="${S}/adv_cmds-${MD_VER}"
	for t in md ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/ || die
		doman "${TS}/${t}/${t}.1"
	done
}
