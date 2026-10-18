# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_PN=PyOTP
PYPI_VERIFY_REPO=https://github.com/pyauth/pyotp
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="PyOTP is a Python library for generating and verifying one-time passwords"
HOMEPAGE="
	https://github.com/pyauth/pyotp/
	https://pypi.org/project/PyOTP/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
