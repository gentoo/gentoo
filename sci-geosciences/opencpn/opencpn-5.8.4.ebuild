# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit wxwidgets xdg cmake toolchain-funcs

DOC_VERSION="4.8.2.0"

DESCRIPTION="a free, open source software for marine navigation"
HOMEPAGE="https://opencpn.org/"
SRC_URI="
	https://github.com/OpenCPN/OpenCPN/archive/refs/tags/Release_${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://launchpad.net/~opencpn/+archive/ubuntu/${PN}/+files/${PN}-doc_${DOC_VERSION}.orig.tar.xz )"
S="${WORKDIR}/OpenCPN-Release_${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc lzma"

RDEPEND="
	app-arch/bzip2
	dev-libs/openssl:=
	dev-libs/tinyxml
	lzma? ( app-arch/xz-utils )
	media-libs/freetype:2
	media-libs/glew:0
	media-libs/jasper
	media-libs/portaudio
	net-misc/curl
	sys-libs/zlib
	virtual/libusb:1
	virtual/opengl
	x11-base/xorg-proto
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}=[opengl,X]
	"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-cpp/gtest
	dev-libs/rapidjson
	sys-apps/lsb-release
	sys-devel/gettext
	"

src_prepare() {
	default
	# see bug #907759
	sed -i "s/ cc / $(tc-getBUILD_CC) /" "${S}"/CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	use doc && HTML_DOCS=( "${S}"/../${PN}/doc/. )

	setup-wxwidgets
	local mycmakeargs=(
		-DUSE_GARMINHOST=ON
	)
#		-DUSE_S57=ON
#		-DBUNDLE_TCDATA=ON
#		-DBUNDLE_GSHHS=CRUDE

	cmake_src_configure
}

src_install() {
	default
	cmake_src_install
	mv "${D}/usr/share/doc/${PN}"/* "${D}/usr/share/doc/${PF}" || die
	rmdir "${D}/usr/share/doc/${PN}"
}

pkg_postinst() {
	xdg_pkg_postinst

	if use doc; then
		einfo "Documentation is available at file:///usr/share/doc/${PF}/html/help_en_US.html"
	fi
}
