# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit wxwidgets xdg cmake

DOC_VERSION="4.8.2.0"

DESCRIPTION="a free, open source software for marine navigation"
HOMEPAGE="https://opencpn.org/"
SRC_URI="
	https://github.com/OpenCPN/OpenCPN/archive/v${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://launchpad.net/~opencpn/+archive/ubuntu/${PN}/+files/${PN}-doc_${DOC_VERSION}.orig.tar.xz )"
S="${WORKDIR}/OpenCPN-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc lzma opengl"

RDEPEND="
	app-arch/bzip2
	lzma? ( app-arch/xz-utils )
	dev-libs/tinyxml
	media-libs/freetype:2
	media-libs/portaudio
	net-misc/curl
	sys-libs/zlib
	opengl? ( virtual/opengl )
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	sys-apps/lsb-release"

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_configure() {
	use doc && HTML_DOCS=( "${S}"/../${PN}/doc/. )

	setup-wxwidgets
	local mycmakeargs=(
		-DUSE_S57=ON
		-DUSE_GARMINHOST=ON
		-DBUNDLE_GSHHS=CRUDE
		-DBUNDLE_TCDATA=ON
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	if use doc; then
		einfo "Documentation is available at file:///usr/share/doc/${PF}/html/help_en_US.html"
	fi
}
