# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

MY_P="${PN^}-${PV}"
DESCRIPTION="Ctypes-based simple ImageMagick binding for Python"
HOMEPAGE="http://wand-py.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-gfx/imagemagick"
BDEPEND="
	test? (
		media-gfx/imagemagick[fftw,jpeg,png,truetype,xml]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	# PDF support is blocked by the default ImageMagick security policy
	pytest -vv --skip-pdf || die "Tests fail with ${EPYTHON}"
}
