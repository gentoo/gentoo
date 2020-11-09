# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"
RESTRICT="test"

S=${WORKDIR}/${P}/src

PATCHES=(
	# support env passthrough for Gentoo ebuilds
	"${FILESDIR}"/scons-3.0.1-env-passthrough.patch
	# respect CC, CXX, C*FLAGS, LDFLAGS by default
	"${FILESDIR}"/scons-3.0.3-respect-cc-etc-r1.patch
)

src_unpack() {
	mkdir -p "${P}"/src || die
	tar -C "${P}"/src --strip-components=1 -xzf "${DISTDIR}/${P}.tar.gz" || die
}

src_prepare() {
	# apply patches relatively to top directory
	cd "${WORKDIR}/${P}" || die
	distutils-r1_src_prepare

	# remove half-broken, useless custom commands
	# and fix manpage install location
	sed -i -e '/cmdclass/,/},$/d' \
		-e '/data_files/s:man/:share/man/:' "${S}"/setup.py || die
}

python_install_all() {
	local DOCS=( {CHANGES,README,RELEASE}.txt )
	distutils-r1_python_install_all
	rm "${ED}/usr/bin/scons.bat" || die

	use doc && dodoc "${DISTDIR}"/${P}-user.{pdf,html}
}
