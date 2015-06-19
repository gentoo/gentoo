# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ssh/ssh-1.8.0-r1.ebuild,v 1.3 2015/04/08 08:05:27 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="SSH2 protocol library"
HOMEPAGE="http://pypi.python.org/pypi/ssh"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc examples"

RDEPEND=">=dev-python/pycrypto-2.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" test.py --verbose || die
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		dohtml docs/*
	fi

	if use examples; then
		docompress -x usr/share/doc/${PF}/demos/
		insinto /usr/share/doc/${PF}
		doins -r demos
	fi
}
