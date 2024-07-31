# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg

MY_COMMIT="8f01c76f0ec727fa336cb2cb6a645a58e3a29e64"
DESCRIPTION="FFmpeg-based simple video cutter & joiner with a modern PyQt5 GUI"
HOMEPAGE="http://vidcutter.ozmartians.com https://github.com/ozmartian/vidcutter"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ozmartian/vidcutter"
else
	SRC_URI="https://github.com/ozmartian/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	>=media-video/mpv-0.25:=[libmpv]
"
RDEPEND="${DEPEND}
	>=dev-python/PyQt5-5.7[dbus,multimedia,widgets,${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	media-video/ffmpeg[X,encode]
	media-video/mediainfo"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	distutils-r1_src_install
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
}
