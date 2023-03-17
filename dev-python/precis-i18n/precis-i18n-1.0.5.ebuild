# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Internationalized Usernames and Passwords"
HOMEPAGE="
	https://github.com/byllyfish/precis_i18n/
	https://pypi.org/project/precis-i18n/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"

distutils_enable_tests unittest

python_test() {
	eunittest -s test
}
