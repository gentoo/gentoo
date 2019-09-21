# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/0_/}"
DESCRIPTION="Quickly searches the network for game servers"
HOMEPAGE="http://uglygs.uglypunk.com/"
SRC_URI="ftp://ftp.uglypunk.com/uglygs/current/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~x86"
IUSE=""

DEPEND="net-analyzer/rrdtool[graph]
	dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${PV}-uglygs.conf.patch
	sed -i \
		-e "s:GENTOO_DIR:/usr/$(get_libdir)/${PN}:" uglygs.conf || die
	eapply "${FILESDIR}"/${PV}-uglygs.pl.patch
	sed -i \
		-e "s:GENTOO_DIR:/etc:" uglygs.pl || die
	sed -i \
		-e "s/strndup/${PN}_strndup/" qstat/qstat.c || die
}

src_compile() {
	emake -C qstat CFLAGS="${CFLAGS}"
}

src_install() {
	insinto /etc
	doins uglygs.conf qstat/qstat.cfg

	dobin uglygs.pl

	insinto /usr/"$(get_libdir)"/${PN}
	doins -r data templates tmp
	insinto /usr/"$(get_libdir)"/${PN}/images
	doins -r images/{avp2,bds,default.gif,hls,j2s,mhs,q3s,rws,sf2s,uns,vcs}
	dosym bds /usr/"$(get_libdir)"/${PN}/images/bdl
	keepdir /usr/"$(get_libdir)"/${PN}/tmp

	exeinto /usr/"$(get_libdir)"/${PN}
	doexe qstat/qstat

	einstalldocs
}
