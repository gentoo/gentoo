# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

MY_P=${P^}
DESCRIPTION="Ctypes-based simple ImageMagick binding for Python"
HOMEPAGE="
	https://docs.wand-py.org/
	https://github.com/emcconville/wand/
	https://pypi.org/project/Wand/
"
SRC_URI="mirror://pypi/${MY_P::1}/${PN^}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

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

PATCHES=(
	"${FILESDIR}"/${P}-sphinx-6.patch
)

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	# PDF support is blocked by the default ImageMagick security policy
	epytest --skip-pdf
}
