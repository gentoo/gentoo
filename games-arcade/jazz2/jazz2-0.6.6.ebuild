# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop dotnet eutils

DESCRIPTION="Open source reimplementation of Jazz Jackrabbit 2"
HOMEPAGE="http://deat.tk/jazz2/"
SRC_URI="https://github.com/deathkiller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="gles2-only server"

RDEPEND="
	dev-lang/mono
	media-libs/libopenmpt
	media-libs/libsdl2[video]
	media-libs/openal
	gles2-only? ( media-libs/mesa[gles2] )
	!gles2-only? ( virtual/opengl )
"

FRAMEWORK="4.5.2"
DIR="/usr/share/${PN}"

src_prepare() {
	default

	# Android/WASM only.
	rm -r Content/Shaders.ES30/ || die

	if use gles2-only; then
		rm -r Content/Shaders/ || die
		mv Content/_ES20/* Content/ || die
	else
		rm -r Content/_ES20/ || die
	fi
}

src_compile() {
	local TARGET

	MAIN_TARGETS="Jazz2 $(usex server Jazz2.Server '') Tools/Import"
	EXT_TARGETS="OpenTKBackend $(usex gles2-only Es20Backend GL21Backend)"

	for TARGET in ${MAIN_TARGETS}; do
		cd "${S}/${TARGET}" || die
		exbuild "${TARGET##*/}.csproj"
	done

	for TARGET in ${EXT_TARGETS}; do
		cd "${S}/Extensions/${TARGET}" || die
		exbuild "${TARGET##*/}.csproj"
	done
}

src_install() {
	local TARGET

	insinto "${DIR}"
	# TODO: Package OpenTK.
	doins -r Content/ Packages/AdamsLair.OpenTK.*/lib/net*/*

	for TARGET in ${MAIN_TARGETS}; do
		doins "${TARGET}/Bin/Release/${TARGET##*/}.exe"
	done

	insinto "${DIR}"/Extensions
	for TARGET in ${EXT_TARGETS}; do
		doins "Extensions/${TARGET}/Jazz2/Bin/Release/Extensions/${TARGET}.core.dll"
	done

	make_wrapper ${PN} "mono '${EPREFIX}${DIR}/Jazz2.exe'"
	make_wrapper ${PN}-import "mono '${EPREFIX}${DIR}/Import.exe'"
	use server && make_wrapper ${PN}-server "mono '${EPREFIX}${DIR}/Jazz2.Server.exe'"

	newicon Jazz2/Icon.ico ${PN}.ico
	make_desktop_entry ${PN} "Jazz² Resurrection" ${PN}.ico
}
