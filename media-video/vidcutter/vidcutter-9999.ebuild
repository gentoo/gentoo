# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg

DESCRIPTION="FFmpeg-based simple video cutter & joiner with a modern PyQt5 GUI"
HOMEPAGE="http://vidcutter.ozmartians.com https://github.com/ozmartian/vidcutter"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ozmartian/vidcutter"
else
	SRC_URI="https://github.com/ozmartian/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

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
