# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Monica is a Monitor Calibration Tool"
HOMEPAGE="https://web.archive.org/web/20201111203551/http://freshmeat.sourceforge.net/projects/monica https://web.archive.org/web/20051016203856/http://www.pcbypaul.com:80/linux/monica.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND=">=x11-libs/fltk-1.1:1"
RDEPEND="${DEPEND}
	x11-apps/xgamma"

DOCS=( authors ChangeLog news readme )
PATCHES=(
	"${FILESDIR}"/${PN}-3.7-makefile-cleanup.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-fprintf.patch
	"${FILESDIR}"/${P}-exit.patch
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
