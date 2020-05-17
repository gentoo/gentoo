# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7,8} )

inherit distutils-r1

MY_P="${PN^}-${PV}"
DESCRIPTION="Ctypes-based simple ImageMagick binding for Python"
HOMEPAGE="http://wand-py.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="media-gfx/imagemagick"
BDEPEND="
	test? (
		media-gfx/imagemagick[fftw,jpeg,png,truetype,xml]
		>=dev-python/pytest-5.3.5[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs

python_test() {
	# PDF support is blocked by the default ImageMagick security policy
	pytest -vv --skip-pdf || die "Tests fail with ${EPYTHON}"
}
