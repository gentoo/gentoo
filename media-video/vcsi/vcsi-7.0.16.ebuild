# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

MY_COMMIT="a42353ec9b17e2feb964c0f78830b836625cf148"

DESCRIPTION="Create thumbnail sheets from video files"
HOMEPAGE="https://github.com/amietn/vcsi"
SRC_URI="https://github.com/amietn/vcsi/archive/${MY_COMMIT}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg,truetype,${PYTHON_USEDEP}]
	dev-python/texttable[${PYTHON_USEDEP}]
	media-fonts/dejavu
	media-video/ffmpeg"

distutils_enable_tests pytest

S="${WORKDIR}"/vcsi-${MY_COMMIT}
