# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="Pyrex-${PV}"

DESCRIPTION="A language for writing Python extension modules"
HOMEPAGE="https://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/"
SRC_URI="https://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
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
