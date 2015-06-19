# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pixz/pixz-1.0.2.ebuild,v 1.4 2013/06/10 17:23:29 zerochaos Exp $

EAPI=5

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="Parallel Indexed XZ compressor"
HOMEPAGE="https://github.com/vasi/pixz"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/vasi/pixz.git"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="static"

LIB_DEPEND=">=app-arch/libarchive-2.8:=[static-libs(+)]
	>=app-arch/xz-utils-5[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-lm.patch
}

src_configure() {
	use static && append-ldflags -static
}

src_compile() {
	emake CC="$(tc-getCC)" OPT=""
}

src_install() {
	dobin pixz
	doman pixz.1
	dodoc README TODO
}
