# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Pytest plugin for testing console scripts"
HOMEPAGE="https://github.com/kvas-it/pytest-console-scripts"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/pytest-4.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
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
	epytest -o tmp_path_retention_count=1
	rm "${script}" || die
}
