# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="POSIX ACLs (Access Control Lists) for Python"
HOMEPAGE="https://pylibacl.k1024.org/
	https://pypi.org/project/pylibacl/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="sys-apps/acl"
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]"
# Tests are missing in the tarball.
RESTRICT="test"

python_test() {
	if ! "${PYTHON}" test/test_acls.py; then
		eerror
		eerror "If you got the following errors:"
		eerror "\"IOError: [Errno 95] Operation not supported\","
		eerror "then you should remount the filesystem containing"
		eerror "build directory with \"acl\" option enabled."
		eerror
		die "Tests fail with ${EPYTHON}"
	fi
}
