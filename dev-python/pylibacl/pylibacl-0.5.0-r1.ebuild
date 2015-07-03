# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylibacl/pylibacl-0.5.0-r1.ebuild,v 1.5 2015/07/03 10:22:07 ago Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="POSIX ACLs (Access Control Lists) for Python"
HOMEPAGE="http://sourceforge.net/projects/pylibacl/ http://pypi.python.org/pypi/pylibacl"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~ia64 ~mips ~ppc ppc64 ~sh ~sparc x86"
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
