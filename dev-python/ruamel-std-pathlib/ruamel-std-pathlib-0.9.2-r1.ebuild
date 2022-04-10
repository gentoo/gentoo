# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

MY_P="${PN//-/.}-${PV}"
DESCRIPTION="Ruamel enhancements to pathlib and pathlib2"
HOMEPAGE="
	https://pypi.org/project/ruamel.std.pathlib/
	https://sourceforge.net/projects/ruamel-std-pathlib/
"
# PyPI tarballs do not include tests
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz -> ${P}.tar.xz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	# this is needed to keep the tests working while
	# dev-python/namespace-ruamel is still installed
	cat > "${BUILD_DIR}/install$(python_get_sitedir)"/ruamel/__init__.py <<-EOF || die
		__path__ = __import__('pkgutil').extend_path(__path__, __name__)
	EOF
	epytest
	rm "${BUILD_DIR}/install$(python_get_sitedir)"/ruamel/__init__.py || die
}
