# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils flag-o-matic

DESCRIPTION="Qt IBus library and Qt input method plugin"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/ibus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="app-i18n/ibus
	dev-libs/icu:=
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	sys-apps/dbus
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}"/${PN}-doc.patch )

src_configure() {
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DLIBDIR=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		emake -C "${BUILD_DIR}" docs
	fi
}

src_install() {
	if use doc; then
		HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	fi

	cmake-utils_src_install
}
