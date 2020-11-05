# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

EGIT_COMMIT=2ae494bd2e3303141a703f32e44263e083c1ffb0
DESCRIPTION="POSIX ACLs (Access Control Lists) for Python"
HOMEPAGE="
	https://pylibacl.k1024.org/
	https://pypi.org/project/pylibacl/
	https://github.com/iustin/pylibacl/"
SRC_URI="
	https://github.com/iustin/pylibacl/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~mips ppc ~ppc64 sparc x86"

RDEPEND="sys-apps/acl"
DEPEND=${RDEPEND}

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
