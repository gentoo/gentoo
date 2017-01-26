# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A lightweight DLNA/UPNP/Chromecast streaming server for PulseAudio"
HOMEPAGE="https://github.com/masmu/pulseaudio-dlna"
SRC_URI="https://github.com/masmu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/protobuf-python-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/docopt-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/futures-2.1.6[${PYTHON_USEDEP}]
	dev-python/librsvg-python[${PYTHON_USEDEP}]
	>=dev-python/lxml-3[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.8[${PYTHON_USEDEP}]
	>=dev-python/notify2-0.3[${PYTHON_USEDEP}]
	>=dev-python/psutil-1.2.1[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/zeroconf-0.17[${PYTHON_USEDEP}]
	|| (
		( media-video/ffmpeg[encode,faac,mp3,opus,vorbis] )
		( media-video/libav[encode,faac,mp3,opus,vorbis] )
		( media-libs/faac
			media-libs/flac
			media-sound/lame
			media-sound/opus-tools
			media-sound/sox
			media-sound/vorbis-tools )
	)
	virtual/python-futures[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-sound/pulseaudio"

src_install() {
	distutils-r1_src_install

	insinto /usr/share/applications
	doins "${FILESDIR}/${PN}.desktop"
}
