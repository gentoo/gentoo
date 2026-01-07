# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

DESCRIPTION="Cartoon style multiplayer first-person shooter"
HOMEPAGE="https://worldofpadman.net/"
SRC_URI="https://github.com/PadWorld-Entertainment/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/PadWorld-Entertainment/${PN}/releases/download/v${PV}/wop-${PV}-unified.zip"

LICENSE="GPL-2 worldofpadman"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+opengl"

# bundled libs (bug #963154):
# media-libs/libjpeg-turbo:=
# media-libs/libtheora
# media-libs/libogg
# media-libs/libvorbis
RDEPEND="
	media-libs/libsdl2[joystick,opengl?,video,X]
	media-libs/openal
	net-misc/curl
	virtual/glu
	virtual/zlib:=
	opengl? ( virtual/opengl )
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

DOCS=( docs/id-readme.txt docs/ioq3-readme.md docs/voip-readme.txt CHANGELOG.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.7-c23.patch # bug 944329, git main
)

src_prepare() {
	rm -r libs/SDL2 || die # unused bundled lib, bug #964479
	cmake_src_prepare
}

src_configure() {
	local arch

	if use amd64 ; then
		arch=x86_64
	elif use x86 ; then
		arch=i386
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/share/${PN}
		-DCMAKE_INSTALL_RPATH=/usr/share/${PN}
		-DARCH=${arch}
		-DBUILD_CLIENT=ON # no benefit to disable this as-is
		# BUILD_SERVER: no extra deps; was: $(usex dedicated OFF ON)
		-DBUILD_RENDERER_OPENGL2=$(usex opengl)
		-DBUILD_RENDERER_VULKAN=OFF
		-DUSE_CURL_DLOPEN=OFF
		-DUSE_OPENAL_DLOPEN=OFF
		-DUSE_RENDERER_DLOPEN=OFF
		-DDEFAULT_BASEDIR=/usr/share/${PN}
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	mkdir -p "${ED}"/usr/bin || die
	mv "${ED}"/usr/share/${PN}/wopded.* "${ED}"/usr/bin/${PN}-ded || die

	mv "${ED}"/usr/share/${PN}/wop.* "${ED}"/usr/bin/${PN} || die
	newicon misc/wop.svg ${PN}.svg
	make_desktop_entry --eapi9 ${PN} -n "World of Padman"

	insinto /usr/share/${PN}/wop
	doins "${WORKDIR}"/wop/*.pk3
	doins "${WORKDIR}"/wop/*.cfg

	local HTML_DOCS=( XTRAS/{readme,readme.html} )
	einstalldocs
}
