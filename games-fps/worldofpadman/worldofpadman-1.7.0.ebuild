# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

DESCRIPTION="A cartoon style multiplayer first-person shooter"
HOMEPAGE="https://worldofpadman.net/"
SRC_URI="https://github.com/PadWorld-Entertainment/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/PadWorld-Entertainment/${PN}/releases/download/v${PV}/wop-${PV}-unified.zip"

LICENSE="GPL-2 worldofpadman"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dedicated +opengl"

RDEPEND="
	sys-libs/zlib
	!dedicated? (
		media-libs/libjpeg-turbo:=
		media-libs/libsdl[joystick,video,X]
		media-libs/libtheora
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
		net-misc/curl
		virtual/glu
		opengl? (
			media-libs/libsdl[opengl]
			virtual/opengl
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

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
		-DBUILD_CLIENT=$(usex dedicated OFF ON)
		-DBUILD_RENDERER_OPENGL2=$(usex opengl)
		-DBUILD_RENDERER_VULKAN=OFF
		-DUSE_CURL_DLOPEN=OFF
		-DUSE_OPENAL_DLOPEN=OFF
		-DUSE_RENDERER_DLOPEN=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	mkdir -p "${ED}"/usr/bin || die
	mv "${ED}"/usr/share/${PN}/wopded.* "${ED}"/usr/bin/${PN}-ded || die

	if ! use dedicated ; then
		mv "${ED}"/usr/share/${PN}/wop.* "${ED}"/usr/bin/${PN} || die
		newicon misc/wop.svg ${PN}.svg
		make_desktop_entry ${PN} "World of Padman"
	fi

	insinto /usr/share/${PN}/wop
	doins "${WORKDIR}"/wop/*.pk3
	doins "${WORKDIR}"/wop/*.cfg

	cd docs || die
	dodoc id-readme.txt \
		ioq3-readme.md \
		voip-readme.txt \
		../CHANGELOG.md

	HTML_DOCS="../XTRAS/readme ../XTRAS/readme.html" einstalldocs
}
