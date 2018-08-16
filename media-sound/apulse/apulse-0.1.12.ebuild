# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib cmake-multilib

DESCRIPTION="PulseAudio emulation for ALSA"
HOMEPAGE="https://github.com/i-rinat/apulse"
SRC_URI="https://github.com/i-rinat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+pa-headers test"

DEPEND="dev-libs/glib:2[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	pa-headers? ( !media-sound/pulseaudio ) "
RDEPEND="${DEPEND}
	!!media-plugins/alsa-plugins[pulseaudio]"

MULTILIB_CHOST_TOOLS=( /usr/bin/apulse )

src_prepare() {
	cmake-utils_src_prepare

	# Ensure all relevant libdirs are added, to support all ABIs
	DIRS=
	_add_dir() { DIRS="${EPREFIX}/usr/$(get_libdir)/apulse${DIRS:+:${DIRS}}"; }
	multilib_foreach_abi _add_dir
	sed -e "s#@@DIRS@@#${DIRS}#g" "${FILESDIR}"/apulse > "${T}"/apulse || die
}

multilib_src_configure() {
	local mycmakeargs=("-DAPULSEPATH=${EPREFIX}/usr/$(get_libdir)/apulse")
	cmake-utils_src_configure
}

multilib_src_test() {
	emake check
}

multilib_src_install_all() {
	cmake-utils_src_install
	einstalldocs
	dobin "${T}"/apulse
	use pa-headers && doheader -r 3rdparty/pulseaudio-headers/pulse
}
