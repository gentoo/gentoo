# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="POSIX ACLs (Access Control Lists) for Python"
HOMEPAGE="
	https://pylibacl.k1024.org/
	https://pypi.org/project/pylibacl/
	https://github.com/iustin/pylibacl/"
SRC_URI="
	https://github.com/iustin/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~mips ppc ppc64 sparc x86"

RDEPEND="sys-apps/acl"
DEPEND=${RDEPEND}

distutils_enable_sphinx doc
distutils_enable_tests pytest

python_test() {
	if ! pytest -vv; then
		eerror
		eerror "If you got the following errors:"
		eerror "\"IOError: [Errno 95] Operation not supported\","
		eerror "then you should remount the filesystem containing"
		eerror "build directory with \"acl\" option enabled."
		eerror
		die "Tests fail with ${EPYTHON}"
	fi
}
