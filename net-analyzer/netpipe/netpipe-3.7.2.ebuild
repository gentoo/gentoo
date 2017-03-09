# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_PN=NetPIPE
MY_P=${MY_PN}-${PV}

DESCRIPTION="network protocol independent performance evaluator"
HOMEPAGE="http://bitspjoule.org/netpipe/"
SRC_URI="http://bitspjoule.org/netpipe/code/${MY_P}.tar.gz"
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

PATCHES=(
	"${FILESDIR}"/${P}-fix-makefile.patch
	)

S="${WORKDIR}"/${MY_P}

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getLD)" memcpy tcp $(usex ipv6 tcp6 '')
}

src_install() {
	dobin NPmemcpy NPtcp
	use ipv6 && dobin NPtcp6
	doman dox/netpipe.1
	einstalldocs
}
