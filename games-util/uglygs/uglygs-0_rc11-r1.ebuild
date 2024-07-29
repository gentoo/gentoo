# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P/0_/}"
DESCRIPTION="Quickly searches the network for game servers"
HOMEPAGE="http://uglygs.uglypunk.com/"
SRC_URI="ftp://ftp.uglypunk.com/uglygs/current/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

DEPEND="net-analyzer/rrdtool[graph]
	dev-lang/perl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}-uglygs.conf.patch
	"${FILESDIR}"/${PV}-uglygs.pl.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:GENTOO_DIR:/usr/$(get_libdir)/${PN}:" uglygs.conf || die

	sed -i \
		-e "s:GENTOO_DIR:/etc:" uglygs.pl || die

	sed -i \
		-e "s/strndup/${PN}_strndup/" qstat/qstat.c || die
}

src_compile() {
	tc-export CC

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
