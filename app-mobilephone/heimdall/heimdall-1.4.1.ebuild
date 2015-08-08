# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils qt4-r2 udev

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/Benjamin-Dobell/Heimdall/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/Heimdall-${PV}"
else
	inherit git-2
	EGIT_REPO_URI="git://github.com/Benjamin-Dobell/Heimdall.git
		https://github.com/Benjamin-Dobell/Heimdall.git"
fi

DESCRIPTION="Tool suite used to flash firmware onto Samsung Galaxy S devices"
HOMEPAGE="http://www.glassechidna.com.au/products/heimdall/"

LICENSE="MIT"
SLOT="0"
IUSE="qt4"

# virtual/libusb is not precise enough
RDEPEND=">=dev-libs/libusb-1.0.18:1=
	qt4? ( dev-qt/qtcore:4= dev-qt/qtgui:4= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	rm -r libusb-1.0 || die
	cd "${S}/heimdall" || die
	edos2unix configure.ac || die
	eautoreconf
}

src_configure() {
	cd "${S}/libpit" || die
	econf

	cd "${S}/heimdall" || die
	econf

	if use qt4; then
		cd "${S}/heimdall-frontend" || die
		eqmake4 heimdall-frontend.pro OUTPUTDIR=/usr/bin || die
	fi
}

src_compile() {
	emake -C libpit
	emake -C heimdall
	use qt4 && emake -C heimdall-frontend
}

src_install() {
	emake -C heimdall DESTDIR="${D}" udevrulesdir="$(get_udevdir)/rules.d" install
	dodoc Linux/README
	use qt4 && emake -C heimdall-frontend INSTALL_ROOT="${D}" install
}
