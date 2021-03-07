# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="A supersonic micro-framework for building cloud APIs"
HOMEPAGE="https://falconframework.org/ https://pypi.org/project/falcon/"
SRC_URI="https://github.com/falconry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cython"

BDEPEND="cython? ( dev-python/cython[${PYTHON_USEDEP}] )"
RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/python-mimeparse[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_prepare() {
	if ! use cython; then
		sed -i -e 's/if with_cython:/if False:/' setup.py || die
	fi

	default
}

python_test() {
	local deselect=(
		# mujson is unpackaged, test-only dep
		--ignore tests/test_media_handlers.py
		# uses unsafe serialization (unsafe_load)
		--deselect tests/test_httperror.py::TestHTTPError::test_custom_error_serializer
	)

	pytest -vv "${deselect[@]}" || die "Tests failed with ${EPYTHON}"
}
