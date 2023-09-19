# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="NetPIPE"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="network protocol independent performance evaluator"
HOMEPAGE="http://bitspjoule.org/netpipe/"
SRC_URI="http://bitspjoule.org/netpipe/code/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ipv6"

DOCS=(
	bin/feplot
	bin/geplot
	bin/nplaunch
	dox/README
	dox/netpipe_paper.ps
	dox/np_cluster2002.pdf
	dox/np_euro.pdf
)

PATCHES=( "${FILESDIR}"/${P}-fix-makefile.patch )

src_configure() {
	tc-export CC
}

src_compile() {
	emake memcpy tcp $(usev ipv6 tcp6)
}

src_install() {
	dobin NPmemcpy NPtcp $(usev ipv6 NPtcp6)
	doman dox/netpipe.1
	einstalldocs
}
