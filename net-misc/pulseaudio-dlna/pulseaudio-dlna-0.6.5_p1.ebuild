# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit desktop distutils-r1

DESCRIPTION="A lightweight DLNA/UPNP/Chromecast streaming server for PulseAudio"
HOMEPAGE="https://github.com/Cygn/pulseaudio-dlna"

if [[ ${PV} == *9999 ]];then
	EGIT_REPO_URI="https://github.com/Cygn/pulseaudio-dlna"
	inherit git-r3
else
	MY_P=${PN}-${PV/_p/-}

	SRC_URI="https://github.com/Cygn/pulseaudio-dlna/archive/refs/tags/${MY_P}.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_P}

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

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
	>=dev-python/pychromecast-10[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	>=dev-python/dbus-python-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-zeroconf-0.17.4[${PYTHON_USEDEP}]
	gnome-base/librsvg[introspection]
	x11-libs/gtk+:3[introspection]
	|| ( media-sound/pulseaudio-daemon media-sound/pulseaudio[daemon(+)] )
	|| (
		|| (
			media-video/ffmpeg[encode,mp3,opus,vorbis]
			media-video/ffmpeg[encode,fdk,mp3,opus,vorbis]
		)
		(
			media-libs/flac
			media-sound/lame
			media-sound/opus-tools
			media-sound/sox
			media-sound/vorbis-tools
		)
	)"

python_prepare_all() {
	sed -i -e 's/.gz//' setup.py || die

	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install

	domenu "${FILESDIR}"/${PN}.desktop
}
