# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit flag-o-matic wxwidgets xdg cmake toolchain-funcs

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
	app-arch/lz4
	dev-libs/libdnet
	dev-libs/openssl:=
	dev-libs/tinyxml
	lzma? ( app-arch/xz-utils )
	media-libs/freetype:2
	media-libs/glew:0
	media-libs/jasper
	media-libs/portaudio
	net-misc/curl
	>=sci-libs/shapelib-1.6.0
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
	# see bug #907759
	sed -i "s/ cc / $(tc-getBUILD_CC) /" "${S}"/CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/927484
	# https://github.com/OpenCPN/OpenCPN/issues/3782
	filter-lto

	use doc && HTML_DOCS=( "${S}"/../${PN}/doc/. )

	setup-wxwidgets
	local mycmakeargs=(
		-DUSE_GARMINHOST=ON
		-DOCPN_ENABLE_SYSTEM_CMD_SOUND=OFF
		-DOCPN_ENABLE_SNDFILE=OFF
		-DOCPN_USE_BUNDLED_LIBS=OFF
		-DOCPN_BUNDLE_TCDATA=ON
		-DOCPN_BUNDLE_GSHHS=ON
		-DOCPN_BUNDLE_DOCS=ON
		-DOCPN_ENABLE_PORTAUDIO=ON
		-DOCPN_ENABLE_SYSTEM_CMD_SOUND=OFF
		-DOCPN_WXWIDGETS_FORCE_VERSION=${WX_GTK_VER}

	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	/usr/share/doc/opencpn

	mv "${D}/usr/share/doc/${PN}"/* "${D}/usr/share/doc/${PF}" || die
	rmdir "${D}/usr/share/doc/${PN}"
}

pkg_postinst() {
	xdg_pkg_postinst

	if use doc; then
		einfo "Documentation is available at file:///usr/share/doc/${PF}/html/help_en_US.html"
	fi
}
