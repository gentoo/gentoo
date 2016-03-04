# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt4-r2

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions"
HOMEPAGE="http://www.keepassx.org/"
SRC_URI="https://www.keepassx.org/releases/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug pch"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtxmlpatterns:4
	>=x11-libs/libXtst-1.1.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.4.3-gcc47.patch )

src_configure() {
	local conf_pch
	use pch && conf_pch="PRECOMPILED=1" || conf_pch="PRECOMPILED=0"

	eqmake4 ${PN}.pro -recursive \
		PREFIX="${ED}/usr" \
		"${conf_pch}"
}

src_compile() {
	# workaround compile failure due to distcc, bug #214327
	PATH=${PATH/\/usr\/lib\/distcc\/bin:}
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc changelog
}
