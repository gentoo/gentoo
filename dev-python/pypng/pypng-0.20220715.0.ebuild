# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

MY_P=pypng-${P}
DESCRIPTION="Pure Python PNG image encoder/decoder"
HOMEPAGE="
	https://gitlab.com/drj11/pypng/
	https://pypi.org/project/pypng/
"
SRC_URI="
	https://gitlab.com/drj11/pypng/-/archive/${P}/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~riscv x86"

python_test() {
	# let's talk about code quality
	local -x PYTHONPATH=code PATH=code:${PATH}
	"${EPYTHON}" code/test_png.py -v || die "Tests fail with ${EPYTHON}"
}
