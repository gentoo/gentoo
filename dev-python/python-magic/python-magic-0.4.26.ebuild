# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Access the libmagic file type identification library"
HOMEPAGE="
	https://github.com/ahupp/python-magic/
	https://pypi.org/project/python-magic/
"
SRC_URI="
	https://github.com/ahupp/python-magic/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"

RDEPEND="
	sys-apps/file[-python]
"
BDEPEND="
	test? (
		sys-apps/file
	)
"

distutils_enable_tests unittest

python_test() {
	local -x LC_ALL=en_US.UTF-8
	eunittest -p "*_test.py"
}
