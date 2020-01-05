# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A framework for writing asynchronous long-running, high-performance network servers in Python"
HOMEPAGE="https://pypi.org/project/medusa/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

python_install_all() {
	distutils-r1_python_install_all
	dodoc CHANGES.txt docs/*.txt
	dodir /usr/share/doc/${PF}/example
	cp -r demo/* "${ED}usr/share/doc/${PF}/example"
	dohtml docs/*.html docs/*.gif
}
