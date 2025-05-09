# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 xdg

MY_COMMIT="db6818f11bbb4d5598dfc5ceeddf7f81c7078499"
DESCRIPTION="FFmpeg-based simple video cutter & joiner with a modern PyQt5 GUI"
HOMEPAGE="http://vidcutter.ozmartians.com https://github.com/ozmartian/vidcutter"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ozmartian/vidcutter"
else
	SRC_URI="https://github.com/ozmartian/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

S="${WORKDIR}/${PN}-${MY_COMMIT}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	>=media-video/mpv-0.25:=[libmpv]
"
RDEPEND="${DEPEND}
	>=dev-python/pyqt5-5.7[dbus,multimedia,widgets,${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	media-video/ffmpeg[X,encode(+)]
	media-video/mediainfo
"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# https://bugs.gentoo.org/929679
	rm vidcutter/libs/pympv/mpv.c || die
	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
}
