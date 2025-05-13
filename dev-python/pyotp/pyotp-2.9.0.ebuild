# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="PyOTP is a Python library for generating and verifying one-time passwords"
HOMEPAGE="
	https://github.com/pyauth/pyotp/
	https://pypi.org/project/pyotp/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

distutils_enable_tests unittest
