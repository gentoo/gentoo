# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Pytest plugin for testing console scripts"
HOMEPAGE="https://github.com/kvas-it/pytest-console-scripts"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/pytest-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local script="${BUILD_DIR}/install${EPREFIX}/usr/bin/pytest"
	cat > "${script}" <<-EOF
		#!/usr/bin/env python
		import pytest
		import sys
		sys.exit(pytest.console_main())
	EOF
	chmod +x "${script}" || die
	epytest -x
	rm "${script}" || die
}
