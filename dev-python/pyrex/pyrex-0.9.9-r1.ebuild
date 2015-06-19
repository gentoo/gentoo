# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyrex/pyrex-0.9.9-r1.ebuild,v 1.16 2015/04/08 08:04:54 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_P="Pyrex-${PV}"

DESCRIPTION="A language for writing Python extension modules"
HOMEPAGE="http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/"
SRC_URI="http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE="examples"

S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND=""
DOCS=( CHANGES.txt README.txt ToDo.txt USAGE.txt )

python_install_all() {
	distutils-r1_python_install_all

	dohtml -A c -r Doc/.

	if use examples; then
		dodoc -r Demos
		docompress -x /usr/share/doc/${PF}/Demos
	fi
}
