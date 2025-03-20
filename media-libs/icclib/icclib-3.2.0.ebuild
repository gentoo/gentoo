# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

MY_P="ICCLib_V${PV}"

DESCRIPTION="Library for reading and writing ICC color profile files"
HOMEPAGE="https://https://argyllcms.com/icclibsrc.html"
SRC_URI="https://www.argyllcms.com/${MY_P}_src.zip -> ${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_prepare() {
	default

	cp "${FILESDIR}"/meson-"${PV}".build ./meson.build || die "Failed to move corrected build system"
}

src_test() {
	"${BUILD_DIR}"/iccdump sRGB.icm || die
}

src_install() {
	meson_install

	doheader icc*.h
	dodoc Readme.txt todo.txt log.txt
}
