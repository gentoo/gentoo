# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Monica is a Monitor Calibration Tool"
HOMEPAGE="http://freecode.com/projects/monica"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=x11-libs/fltk-1.1:1"
RDEPEND="${DEPEND}
	x11-apps/xgamma"

DOCS=( authors ChangeLog news readme )
PATCHES=(
	"${FILESDIR}"/${PN}-3.6-makefile-cleanup.patch
	"${FILESDIR}"/${P}-gcc44.patch
)

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LINK="$(tc-getCXX)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin monica
	einstalldocs
}
