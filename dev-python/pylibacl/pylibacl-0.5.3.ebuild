# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="POSIX ACLs (Access Control Lists) for Python"
HOMEPAGE="https://pylibacl.k1024.org/
	https://pypi.org/project/pylibacl/"
SRC_URI="https://github.com/iustin/${PN}/archive/${PN}-v${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"

RDEPEND="sys-apps/acl"
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${PN}-v${PV}"

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
