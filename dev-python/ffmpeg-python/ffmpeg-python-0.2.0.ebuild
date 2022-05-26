# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python bindings for FFmpeg with complex filtering support"
HOMEPAGE="https://github.com/kkroening/ffmpeg-python"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kkroening/${PN}.git"
else
	SRC_URI="https://github.com/kkroening/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	media-video/ffmpeg
"
BDEPEND="test? ( dev-python/pytest-mock[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${P}-_run.py-collections.patch
	"${FILESDIR}"/${P}-setup.py-pytest-runner.patch
)

distutils_enable_tests pytest
distutils_enable_sphinx doc/src
