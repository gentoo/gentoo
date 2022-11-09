# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_COMMIT="fa7aa8ca781d0fe3188eea76f79c5702bf9b7330"

DESCRIPTION="Create thumbnail sheets from video files"
HOMEPAGE="https://github.com/amietn/vcsi"
SRC_URI="https://github.com/amietn/vcsi/archive/${MY_COMMIT}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg,truetype,${PYTHON_USEDEP}]
	dev-python/texttable[${PYTHON_USEDEP}]
	media-fonts/dejavu
	media-video/ffmpeg"

distutils_enable_tests pytest

S="${WORKDIR}"/vcsi-${MY_COMMIT}
