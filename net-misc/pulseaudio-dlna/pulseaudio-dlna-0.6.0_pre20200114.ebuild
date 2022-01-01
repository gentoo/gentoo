# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 )

inherit desktop distutils-r1

DESCRIPTION="A lightweight DLNA/UPNP/Chromecast streaming server for PulseAudio"
HOMEPAGE="https://github.com/masmu/pulseaudio-dlna"

SRC_URI="https://github.com/masmu/pulseaudio-dlna/archive/b0db8137224f5a293329a60187365168304c3768.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/pulseaudio-dlna-b0db8137224f5a293329a60187365168304c3768"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=dev-python/protobuf-python-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/docopt-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.1.10[${PYTHON_USEDEP}]
	>=dev-python/notify2-0.3[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.4.7[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	>=dev-python/pyroute2-0.3.5[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-3[${PYTHON_USEDEP}]
	>=dev-python/pychromecast-2.3.0[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/dbus-python-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/zeroconf-0.17.4[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	gnome-base/librsvg[introspection]
	x11-libs/gtk+:3[introspection]
	|| (
		|| (
			media-video/ffmpeg[encode,fdk,mp3,opus,vorbis] )
		(
			media-libs/faac
			media-libs/flac
			media-sound/lame
			media-sound/opus-tools
			media-sound/sox
			media-sound/vorbis-tools
		)
	)"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-sound/pulseaudio"

python_prepare_all() {
	sed -i '/dbus-python/d' setup.py || die
	sed -i '/notify2/d' setup.py || die
	sed -i '/docopt/d' setup.py || die
	sed -i '/pychromecast/d' setup.py || die
	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install

	domenu "${FILESDIR}/${PN}.desktop"
}
