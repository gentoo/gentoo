# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Pure Python PNG image encoder/decoder"
HOMEPAGE="
	https://github.com/drj11/pypng/
	https://pypi.org/project/pypng/"
SRC_URI="https://github.com/drj11/pypng/archive/${P}.tar.gz"
S=${WORKDIR}/pypng-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

python_test() {
	"${EPYTHON}" code/test_png.py -v || die "Tests fail with ${EPYTHON}"
}
