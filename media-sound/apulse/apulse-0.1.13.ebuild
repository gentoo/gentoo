# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit multilib cmake-multilib

DESCRIPTION="PulseAudio emulation for ALSA"
HOMEPAGE="https://github.com/i-rinat/apulse"
SRC_URI="https://github.com/i-rinat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug sdk test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/glib:2[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	sdk? ( !media-sound/pulseaudio ) "
RDEPEND="${DEPEND}
	!!media-plugins/alsa-plugins[pulseaudio]"

PATCHES=(
	"${FILESDIR}/sdk.patch"
	"${FILESDIR}/check-key-before-remove.patch"
	"${FILESDIR}/man.patch"
)

src_prepare() {
	cmake_src_prepare

	if ! use sdk; then
		# Ensure all relevant libdirs are added, to support all ABIs
		DIRS=
		_add_dir() { DIRS="${EPREFIX}/usr/$(get_libdir)/apulse${DIRS:+:${DIRS}}"; }
		multilib_foreach_abi _add_dir
		sed -e "s#@@DIRS@@#${DIRS}#g" "${FILESDIR}"/apulse > "${T}"/apulse || die
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		"-DINSTALL_SDK=$(usex sdk)"
		"-DLOG_TO_STDERR=$(usex debug)"
		"-DWITH_TRACE=$(usex debug)"
	)
	cmake_src_configure
}

multilib_src_test() {
	emake check
}

multilib_src_install_all() {
	if ! use sdk; then
		_install_wrapper() { newbin "${BUILD_DIR}/apulse" "${CHOST}-apulse"; }
		multilib_foreach_abi _install_wrapper
		dobin "${T}/apulse"
	fi
	einstalldocs
}
