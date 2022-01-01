# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="gstreamer1-plugins-sndio-${PV}"

DESCRIPTION="Sndio audio sink and source for GStreamer"
HOMEPAGE="https://github.com/t6/gstreamer1-plugins-sndio"
SRC_URI="https://github.com/t6/gstreamer1-plugins-sndio/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/gst-plugins-base:1.0
	media-sound/sndio:=
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
