# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MY_P="MySQL-python-${PV}"

DESCRIPTION="Python interface to MySQL"
HOMEPAGE="https://sourceforge.net/projects/mysql-python/ https://pypi.python.org/pypi/MySQL-python"
SRC_URI="mirror://sourceforge/mysql-python/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="virtual/mysql"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

DOCS=( HISTORY README doc/{FAQ,MySQLdb}.txt )

python_configure_all() {
	append-flags -fno-strict-aliasing
}
