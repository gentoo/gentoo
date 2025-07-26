# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=python-xmlsec-${PV}
DESCRIPTION="Python bindings for the XML Security Library"
HOMEPAGE="
	https://github.com/xmlsec/python-xmlsec/
	https://pypi.org/project/xmlsec/
"
SRC_URI="
	https://github.com/xmlsec/python-xmlsec/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

DEPEND="
	dev-libs/xmlsec:=[openssl]
"
RDEPEND="
	${DEPEND}
	dev-python/lxml[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

EPYTEST_DESELECT=(
	# Fragile based on black version?
	tests/test_type_stubs.py::test_xmlsec_constants_stub
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_configure() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

	export PYXMLSEC_OPTIMIZE_SIZE=
	if use debug; then
		# we don't want to use PYXMLSEC_ENABLE_DEBUG envvar,
		# as it forces -O0
		export CPPFLAGS="${CPPFLAGS} -DPYXMLSEC_ENABLE_DEBUG=1"
	fi
}
