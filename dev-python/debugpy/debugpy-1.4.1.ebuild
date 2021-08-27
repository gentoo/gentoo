# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="An implementation of the Debug Adapter Protocol for Python"
HOMEPAGE="https://github.com/microsoft/debugpy/ https://pypi.org/project/debugpy/"
SRC_URI="https://github.com/microsoft/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~sparc"

# There is not enough time in the universe for this test suite
RESTRICT="test"

# These files are included pre-built in the sources
# TODO: Investigate what this is and if/how we can compile this properly
QA_PREBUILT="
	/usr/lib/python*/site-packages/${PN}/_vendored/pydevd/pydevd_attach_to_process/attach_linux_*.so
"

python_prepare_all() {
	# Drop unnecessary and unrecognized option
	# __main__.py: error: unrecognized arguments: -n8
	# Do not timeout
	sed -i \
		-e 's/-n8//g' \
		-e '/timeout/d' \
		pytest.ini || die

	distutils-r1_python_prepare_all
}

distutils_enable_tests pytest
