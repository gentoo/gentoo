# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/amd-adl-sdk/amd-adl-sdk-6.0-r1.ebuild,v 1.3 2014/01/14 13:57:37 ago Exp $

EAPI=5

DESCRIPTION="API to access display driver functionality for ATI graphics cards"
HOMEPAGE="http://developer.amd.com/tools-and-sdks/graphics-development/display-library-adl-sdk/"
SRC_URI="ADL_SDK_${PV}.zip"

LICENSE="AMD-ADL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

RDEPEND="x11-drivers/ati-drivers"
DEPEND="app-arch/unzip"

RESTRICT="fetch"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please visit the download page [1] and save ${A} in ${DISTDIR}"
	einfo "[1] http://developer.amd.com/tools-and-sdks/graphics-development/display-library-adl-sdk/"
}

src_prepare() {
	sed -i -e '/include/a \#include <wchar.h>' include/adl_structures.h || die
}

src_install() {
	use doc && dodoc -r "Public-Documents"/* "adlutil/ADLUTIL User Guide.doc"
	use examples && dodoc -r "Sample" "Sample-Managed"

	insinto "/usr/include/ADL"
	doins include/*
}
