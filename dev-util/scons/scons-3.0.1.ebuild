# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Extensible Python-based build utility"
HOMEPAGE="http://www.scons.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? (
		http://www.scons.org/doc/${PV}/PDF/${PN}-user.pdf -> ${P}-user.pdf
		http://www.scons.org/doc/${PV}/HTML/${PN}-user.html -> ${P}-user.html
	)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc"

python_prepare_all() {
	# remove half-broken, useless custom commands
	# and fix manpage install location
	sed -i -e '/cmdclass/,/}$/d' \
		-e '/data_files/s:man/:share/man/:' setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	local DOCS=( {CHANGES,README,RELEASE}.txt )
	distutils-r1_python_install_all
	rm "${ED%/}/usr/bin/scons.bat" || die

	use doc && dodoc "${DISTDIR}"/${P}-user.{pdf,html}
}
