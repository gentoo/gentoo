# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ircmap/ircmap-0.99.ebuild,v 1.13 2011/05/15 01:25:56 binki Exp $

DESCRIPTION="Scripts to treate diagrams of IRC networks using the LINKS command"
HOMEPAGE="http://pasky.or.cz/~pasky/irc/"
SRC_URI="http://pasky.ji.cz/~pasky/irc/${PN}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${RDEPEND}
	media-gfx/graphviz"
DEPEND="${DEPEND}
		>=sys-apps/sed-4"

S="${WORKDIR}"/${PN}

src_compile() {
	eval $(perl -V:installprivlib)

	sed -i \
		-e "s:/home/pasky/ircmap:${installprivlib}/ircmap:" \
		{ircmapC,ircmapR-aa,ircmapR-gvdot,ircmapR-ircnet,ircmapS}.pl
}

src_install () {
	dodoc README
	dobin ircmapS.pl ircmapC.pl ircmapR-aa.pl ircmapR-gvdot.pl ircmapR-ircnet.pl

	eval $(perl -V:installprivlib)

	insinto /"${installprivlib}"/ircmap
	doins IHash.pm
}

pkg_postinst() {
	elog 'Usage:'
	elog 'IRCSERVER="irc.generic.com ircmapS.pl [-options parameters] \'
	elog '| tee /tmp/sendmethisifitdoesntwork \'
	elog '| ircmapC.pl \'
	elog '| tee /tmp/coredump \'
	elog '| ircmapR-aa.pl > ${IRCSERVER}.txt'
	elog ''
	elog 'cat /tmp/coredump \'
	elog '| ircmapR-gvdot.pl \'
	elog '| dot -Tgif -o  ${IRCSERVER}.gif'
}
