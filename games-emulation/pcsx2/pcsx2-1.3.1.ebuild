# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="ar_SA ca_ES cs_CZ de_DE es_ES fi_FI fr_FR hr_HR hu_HU id_ID it_IT ja_JP ko_KR ms_MY nb_NO pl_PL pt_BR ru_RU sv_SE th_TH tr_TR zh_CN zh_TW"

inherit cmake-utils l10n multilib toolchain-funcs wxwidgets

DESCRIPTION="A PlayStation 2 emulator"
HOMEPAGE="http://www.pcsx2.net"
SRC_URI="https://github.com/PCSX2/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	app-arch/bzip2[abi_x86_32(-)]
	dev-libs/libaio[abi_x86_32(-)]
	media-libs/alsa-lib[abi_x86_32(-)]
	media-libs/libsdl[abi_x86_32(-),joystick,sound]
	media-libs/portaudio[abi_x86_32(-)]
	media-libs/libsoundtouch[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	>=sys-libs/zlib-1.2.4[abi_x86_32(-)]
	virtual/jpeg:62[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	x11-libs/libICE[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/wxGTK:3.0[abi_x86_32(-),X]
"
# Ensure no incompatible headers from eselect-opengl are installed, bug #510730
DEPEND="${RDEPEND}
	>=app-eselect/eselect-opengl-1.3.1
	>=dev-cpp/sparsehash-1.5
"

PATCHES=(
	"${FILESDIR}"/"${P}-egl-optional.patch"
	"${FILESDIR}"/"${P}-packaging.patch"
	"${FILESDIR}"/"${P}-cflags.patch"
)

clean_locale() {
	rm -R "${S}"/locales/"${1}" || die
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary && $(tc-getCC) == *gcc* ]]; then
		if [[ $(gcc-major-version) -lt 4 || $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 7 ]] ; then
			die "${PN} does not compile with gcc less than 4.7"
		fi
	fi
}

src_prepare() {
	cmake-utils_src_prepare
	l10n_for_each_disabled_locale_do clean_locale
}

src_configure() {
	multilib_toolchain_setup x86

	# pcsx2 build scripts will force CMAKE_BUILD_TYPE=Devel
	# if it something other than "Devel|Debug|Release"
	local CMAKE_BUILD_TYPE="Release"

	if use amd64; then
		# Passing correct CMAKE_TOOLCHAIN_FILE for amd64
		# https://github.com/PCSX2/pcsx2/pull/422
		local MYCMAKEARGS=(-DCMAKE_TOOLCHAIN_FILE=cmake/linux-compiler-i386-multilib.cmake)
	fi

	local mycmakeargs=(
		-DARCH_FLAG=
		-DEGL_API=FALSE
		-DEXTRA_PLUGINS=FALSE
		-DGLES_API=FALSE
		-DGLSL_API=FALSE
		-DGTK3_API=FALSE
		-DPACKAGE_MODE=TRUE
		-DOPTIMIZATION_FLAG=
		-DXDG_STD=TRUE

		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_LIBRARY_PATH="/usr/$(get_libdir)/${PN}"
		-DDOC_DIR=/usr/share/doc/"${PF}"
		-DPLUGIN_DIR="/usr/$(get_libdir)/${PN}"
		# wxGTK must be built against same sdl version
		-DSDL2_API=FALSE
		-DWX28_API=FALSE
	)

	WX_GTK_VER="3.0" need-wxwidgets unicode
	cmake-utils_src_configure
}

src_install() {
	# Upstream issue: https://github.com/PCSX2/pcsx2/issues/417
	QA_TEXTRELS="usr/$(get_libdir)/pcsx2/*"

	cmake-utils_src_install
}
