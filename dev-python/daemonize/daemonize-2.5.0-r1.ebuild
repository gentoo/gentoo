# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Library for writing system daemons in Python"
HOMEPAGE="
	https://github.com/thesharp/daemonize/
	https://pypi.org/project/daemonize/
"
SRC_URI="
	https://github.com/thesharp/daemonize/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

python_test() {
	"${EPYTHON}" tests/test.py -v || die "Tests failed with ${EPYTHON}"
}
