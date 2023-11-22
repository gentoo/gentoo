# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="QR Code Generator Library in Multiple Languages"
HOMEPAGE="
	https://github.com/EasyCoding/qrcodegen-cmake
	https://github.com/nayuki/QR-Code-generator
"
SRC_URI="
	https://github.com/EasyCoding/qrcodegen-cmake/archive/v${PV}-cmake2.tar.gz -> qr-code-generator-cmake-${PV}.tar.gz
	https://github.com/nayuki/QR-Code-generator/archive/v${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/QR-Code-generator-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	# Move the CMake files into the project root.
	mv ../qrcodegen-cmake-${PV}-cmake2/* . || die

	cmake_src_prepare
}
