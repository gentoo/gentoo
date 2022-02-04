# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_COMMIT="7c974f7396a5c6e459f7c6033674ad7144e820a8"

DESCRIPTION="Create thumbnail sheets from video files"
HOMEPAGE="https://github.com/amietn/vcsi"
SRC_URI="https://github.com/amietn/vcsi/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg,truetype,${PYTHON_USEDEP}]
	dev-python/texttable[${PYTHON_USEDEP}]
	media-fonts/dejavu
	media-video/ffmpeg"

distutils_enable_tests nose

S="${WORKDIR}"/vcsi-${MY_COMMIT}
