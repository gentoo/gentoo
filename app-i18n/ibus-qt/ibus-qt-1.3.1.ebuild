# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit cmake-utils eutils multilib

MY_P="${P}-Source"
DESCRIPTION="Qt IBus library and Qt input method plugin"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://ibus.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=">=app-i18n/ibus-1.3.7
	>=sys-apps/dbus-1.2
	x11-libs/libX11
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtdbus-4.5:4"
DEPEND="${RDEPEND}
	>=dev-libs/icu-4:=
	dev-util/cmake
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS README TODO"

mycmakeargs="-DLIBDIR=$(get_libdir) -DDOCDIR=${EPREFIX}/usr/share/doc/${PF} all"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2.0.20091217-doc.patch" \
		"${FILESDIR}"/${PN}-1.3.1-display-unset.patch \
		"${FILESDIR}"/${PN}-1.3.1-gold.patch \
		"${FILESDIR}"/${PN}-1.3.1-qvariant.patch
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		cd "${CMAKE_BUILD_DIR}"
		emake docs || die
	fi
}

src_install() {
	if use doc ; then
		HTML_DOCS="${CMAKE_BUILD_DIR}/docs/html/*"
	fi

	cmake-utils_src_install
}
