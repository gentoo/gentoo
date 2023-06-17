# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python classes to extract information from the Linux kernel /proc files"
HOMEPAGE="
	https://git.kernel.org/pub/scm/libs/python/python-linux-procfs/
	https://kernel.googlesource.com/pub/scm/libs/python/python-linux-procfs/python-linux-procfs/
"
SRC_URI="https://cdn.kernel.org/pub/software/libs/python/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

python_test() {
	${EPYTHON} ./bitmasklist_test.py || die "Tests failed with ${EPYTHON}"
}
