# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="EditorConfig core library for use by plugins supporting EditorConfig parsing"
HOMEPAGE="https://github.com/editorconfig/editorconfig-core-c"
SRC_URI="https://github.com/editorconfig/editorconfig-core-c/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doxygen"

RDEPEND="dev-libs/libpcre"
DEPEND="${RDEPEND}
	doxygen? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-core-c-${PV}"

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DBUILD_DOCUMENTATION="$(usex doxygen)"
	)

	cmake-utils_src_configure
}
