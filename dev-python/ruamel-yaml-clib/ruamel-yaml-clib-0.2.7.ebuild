# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="C-based reader/scanner and emitter for dev-python/ruamel-yaml"
HOMEPAGE="
	https://pypi.org/project/ruamel.yaml.clib/
	https://sourceforge.net/projects/ruamel-yaml-clib/
"
# Lacks .pyx files for cythonizing for py3.11
#SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

src_configure() {
	cythonize -3 _ruamel_yaml.pyx || die
}
