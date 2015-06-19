# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/bsd-games-non-free/bsd-games-non-free-2.17.ebuild,v 1.8 2015/02/03 20:22:06 tupone Exp $

EAPI=5
inherit games

DESCRIPTION="collection of games from NetBSD"
HOMEPAGE="http://www.advogato.org/proj/bsd-games/"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/games/${P}.tar.gz"

# See /usr/share/doc/${P}/CHANGES.rogue
LICENSE="|| ( BSD free-noncomm )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

# Set GAMES_TO_BUILD variable to whatever you want
export GAMES_TO_BUILD=${GAMES_TO_BUILD:="rogue"}

src_prepare() {
	sed -i \
		-e '/^CC :/d' \
		-e '/^CXX :/d' \
		Makeconfig.in \
		|| die "sed failed"
	cp "${FILESDIR}"/config.params-gentoo config.params || die "cp failed"
	echo bsd_games_cfg_usrlibdir=\"$(games_get_libdir)\" >> ./config.params
	echo bsd_games_cfg_build_dirs=\"${GAMES_TO_BUILD}\" >> ./config.params
}

src_configure() {
	./configure || die
}

src_compile() {
	emake OPTIMIZE="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

build_game() {
	has ${1} ${GAMES_TO_BUILD}
}

do_statefile() {
	touch "${D}/${GAMES_STATEDIR}/${1}"
	chmod ug+rw "${D}/${GAMES_STATEDIR}/${1}"
}

src_install() {
	dodir "${GAMES_BINDIR}" "${GAMES_STATEDIR}" /usr/share/man/man{1,6}
	make DESTDIR="${D}" install || die "make install failed"
	rm -rf "${D}"/usr/share/doc/bsd-games || die "Remove failed"

	dodoc AUTHORS BUGS ChangeLog ChangeLog.0 NEWS \
		  PACKAGING README README.non-free SECURITY THANKS TODO YEAR2000 \
		  bsd-games-non-free.lsm

	# state files
	build_game rogue && do_statefile rogue.scores

	# extra docs
	build_game rogue && { docinto rogue ; dodoc rogue/{CHANGES,USD.doc/rogue.me}; }

	prepgamesdirs
}
