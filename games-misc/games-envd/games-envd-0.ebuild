# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib games

DESCRIPTION="Environment file for gentoo games"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Games"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa m68k ~mips ppc64 s390 sh x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

S=${WORKDIR}

pkg_setup() {
	games_pkg_setup
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		if [[ -e "${EROOT%/}/etc/env.d/${GAMES_ENVD}" ]] ; then
			einfo "removing ${EROOT%/}/etc/env.d/${GAMES_ENVD}"
			rm "${EROOT%/}/etc/env.d/${GAMES_ENVD}" || die
		fi
	fi
}

src_prepare() {
	local d libdirs

	for d in $(get_all_libdirs) ; do
		libdirs="${libdirs}:${GAMES_PREFIX}/${d}"
	done

	cat <<-EOF > ${GAMES_ENVD} || die
	# if you don't want these added for non-games users
	# see https://bugs.gentoo.org/show_bug.cgi?id=408615
	LDPATH="${libdirs:1}"
	PATH="${GAMES_BINDIR}"
	EOF
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	doenvd ${GAMES_ENVD}
	gamesowners "${ED%/}"/etc/env.d/${GAMES_ENVD}
	gamesperms "${ED%/}"/etc/env.d/${GAMES_ENVD}
}

pkg_preinst() { :; }

pkg_postinst() { :; }
