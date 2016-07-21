# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Python FTP server library"
HOMEPAGE="https://github.com/giampaolo/pyftpdlib https://pypi.python.org/pypi/pyftpdlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="examples ssl"

DEPEND="ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

python_test() {
	"${PYTHON}" test/test_ftpd.py || die
	"${PYTHON}" test/test_contrib.py || die
}

python_install_all() {
	use examples && local EXAMPLES=( demo/. )
	distutils-r1_python_install_all
}
