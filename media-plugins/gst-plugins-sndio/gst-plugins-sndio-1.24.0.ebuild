# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="gstreamer1-plugins-sndio"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sndio audio sink and source for GStreamer"
HOMEPAGE="https://github.com/BSDKaffee/gstreamer1-plugins-sndio"
SRC_URI="https://github.com/BSDKaffee/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/gst-plugins-base:1.0
	>=media-sound/sndio-1.10.0:=
"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export CC
	default
}

src_install() {
	export BSD_INSTALL_LIB="install -m 444"

	default
}
