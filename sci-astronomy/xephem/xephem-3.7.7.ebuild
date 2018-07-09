# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Interactive tool for astronomical ephemeris and sky simulation"
HOMEPAGE="http://www.clearskyinstitute.com/xephem"
SRC_URI="http://97.74.56.125/free/${P}.tar.gz"

LICENSE="XEphem"
SLOT=0
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/motif-2.3:0
	virtual/jpeg:0=
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	sys-apps/groff"

PATCHES=(
	"${FILESDIR}/${P}-respect_env_vars.patch"
	"${FILESDIR}/${P}-implicits.patch"
	"${FILESDIR}/${P}-no_xprint.patch"
)

src_prepare() {
	default
	echo > "${T}"/XEphem "XEphem.ShareDir: /usr/share/${PN}"
	echo > "${T}"/99xephem "XEHELPURL=/usr/share/doc/${PF}/html/xephem.html"
}

src_compile() {
	tc-export CC AR RANLIB
	emake -C GUI/xephem
}

src_install() {
	insinto /usr/share/X11/app-defaults
	has_version '<x11-base/xorg-x11-7.0' && insinto /etc/X11/app-defaults
	doins "${T}"/XEphem
	doenvd "${T}"/99xephem
	dodoc README

	cd GUI/xephem
	dobin xephem
	doman xephem.1
	newicon XEphem.png ${PN}.png
	insinto /usr/share/${PN}
	doins -r auxil catalogs fifos fits gallery lo
	insinto /usr/share/doc/${PF}/html
	doins -r help/*
	make_desktop_entry xephem XEphem ${PN}
}
