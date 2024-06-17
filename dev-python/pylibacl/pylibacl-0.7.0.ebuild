# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="POSIX ACLs (Access Control Lists) for Python"
HOMEPAGE="
	https://pylibacl.k1024.org/
	https://pypi.org/project/pylibacl/
	https://github.com/iustin/pylibacl/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ~mips ppc ppc64 sparc x86"

DEPEND="
	sys-apps/acl
"
RDEPEND="
	${DEPEND}
"

distutils_enable_sphinx doc \
	dev-python/recommonmark
distutils_enable_tests pytest

python_test() {
	if ! nonfatal epytest ; then
		eerror
		eerror "If you got the following errors:"
		eerror "\"IOError: [Errno 95] Operation not supported\","
		eerror "then you should remount the filesystem containing"
		eerror "build directory with \"acl\" option enabled."
		eerror
		die "Tests fail with ${EPYTHON}"
	fi
}
