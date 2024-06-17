# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Ctypes-based simple ImageMagick binding for Python"
HOMEPAGE="
	https://docs.wand-py.org/
	https://github.com/emcconville/wand/
	https://pypi.org/project/Wand/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-gfx/imagemagick
"
BDEPEND="
	test? (
		media-gfx/imagemagick[fftw,jpeg,png,truetype,xml]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	# PDF support is blocked by the default ImageMagick security policy
	epytest --skip-pdf
}
