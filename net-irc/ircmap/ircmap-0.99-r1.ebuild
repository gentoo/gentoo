# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scripts to treate diagrams of IRC networks using the LINKS command"
HOMEPAGE="http://pasky.or.cz/irc/"
SRC_URI="http://pasky.or.cz/irc/${PN}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="
	media-gfx/graphviz
	dev-lang/perl
"
BDEPEND="${RDEPEND}
	>=sys-apps/sed-4
"
DEPEND=""

S="${WORKDIR}"/${PN}

src_compile() {
	sed -i \
		-e "s:/home/pasky/ircmap:/usr/share/ircmap:" \
		{ircmapC,ircmapR-aa,ircmapR-gvdot,ircmapR-ircnet,ircmapS}.pl
}

src_install () {
	dodoc README
	dobin ircmapS.pl ircmapC.pl ircmapR-aa.pl ircmapR-gvdot.pl ircmapR-ircnet.pl

	insinto /usr/share/ircmap
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
