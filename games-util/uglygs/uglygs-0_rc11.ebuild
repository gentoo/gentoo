# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_P=${P/0_/}
DESCRIPTION="quickly searches the network for game servers"
HOMEPAGE="http://uglygs.uglypunk.com/"
SRC_URI="ftp://ftp.uglypunk.com/uglygs/current/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha hppa ppc sparc x86"
IUSE=""

DEPEND="net-analyzer/rrdtool[graph]
	dev-lang/perl"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-uglygs.conf.patch
	sed -i \
		-e "s:GENTOO_DIR:$(games_get_libdir)/${PN}:" uglygs.conf || die
	epatch "${FILESDIR}"/${PV}-uglygs.pl.patch
	sed -i \
		-e "s:GENTOO_DIR:${GAMES_SYSCONFDIR}:" uglygs.pl || die
	sed -i \
		-e "s/strndup/${PN}_strndup/" qstat/qstat.c || die
}

src_compile() {
	emake -C qstat CFLAGS="${CFLAGS}"
}

src_install() {
	insinto "${GAMES_SYSCONFDIR}"
	doins uglygs.conf qstat/qstat.cfg

	dogamesbin uglygs.pl

	insinto "$(games_get_libdir)"/${PN}
	doins -r data templates tmp
	insinto "$(games_get_libdir)"/${PN}/images
	doins -r images/{avp2,bds,default.gif,hls,j2s,mhs,q3s,rws,sf2s,uns,vcs}
	dosym bds "$(games_get_libdir)"/${PN}/images/bdl
	keepdir "$(games_get_libdir)"/${PN}/tmp

	exeinto "$(games_get_libdir)"/${PN}
	doexe qstat/qstat

	dodoc CHANGES README

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Dont forget to setup ${GAMES_SYSCONFDIR}/uglygs.conf and ${GAMES_SYSCONFDIR}/qstat.cfg"
}
