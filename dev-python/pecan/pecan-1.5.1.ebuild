# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A WSGI object-dispatching web framework, lean, fast, with few dependencies"
HOMEPAGE="
	https://github.com/pecan/pecan/
	https://pypi.org/project/pecan/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/webob-1.4[${PYTHON_USEDEP}]
	>=dev-python/mako-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/logutils-0.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/webtest-1.3.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
