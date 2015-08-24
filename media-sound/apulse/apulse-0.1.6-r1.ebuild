# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib cmake-multilib

DESCRIPTION="PulseAudio emulation for ALSA"
HOMEPAGE="https://github.com/i-rinat/apulse"
SRC_URI="https://github.com/i-rinat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/glib:2[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}
	!!media-plugins/alsa-plugins[pulseaudio]"

MULTILIB_CHOST_TOOLS=( /usr/bin/apulse )

multilib_src_configure() {
	local mycmakeargs="-DAPULSEPATH=${EPREFIX}/usr/$(get_libdir)/apulse"

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	dobin "${FILESDIR}"/apulse
}
