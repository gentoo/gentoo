# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/games-envd/games-envd-0.ebuild,v 1.1 2014/03/12 18:47:03 hasufell Exp $

EAPI=5

inherit multilib games

DESCRIPTION="Environment file for gentoo games"
HOMEPAGE="http://www.gentoo.org/proj/en/desktop/games/index.xml"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

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
