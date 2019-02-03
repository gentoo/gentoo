# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Extensible Python-based build utility"
HOMEPAGE="http://www.scons.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? (
		http://www.scons.org/doc/${PV}/PDF/${PN}-user.pdf -> ${P}-user.pdf
		http://www.scons.org/doc/${PV}/HTML/${PN}-user.html -> ${P}-user.html
	)
	test? ( https://github.com/scons/scons/archive/${PV}.tar.gz -> ${P}.gh.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

S=${WORKDIR}/${P}/src

PATCHES=(
	# support env passthrough for Gentoo ebuilds
	"${FILESDIR}"/scons-3.0.1-env-passthrough.patch
	# respect CC, CXX, C*FLAGS, LDFLAGS by default
	"${FILESDIR}"/scons-3.0.1-respect-cc-etc-r1.patch
)

src_unpack() {
	# use the git directory structure, but put pregenerated release
	# inside src/ subdirectory to make our life easier
	if use test; then
		unpack "${P}.gh.tar.gz"
		rm -r "${P}/src" || die
	else
		mkdir "${P}" || die
	fi

	cd "${P}" || die
	unpack "${P}.tar.gz"
	mv "${P}" src || die
}

src_prepare() {
	# apply patches relatively to top directory
	cd "${WORKDIR}/${P}" || die
	distutils-r1_src_prepare

	# remove half-broken, useless custom commands
	# and fix manpage install location
	sed -i -e '/cmdclass/,/}$/d' \
		-e '/data_files/s:man/:share/man/:' "${S}"/setup.py || die
}

python_test() {
	cd "${WORKDIR}/${P}" || die
	"${EPYTHON}" runtest.py -as \
		-j "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" \
		--builddir "${BUILD_DIR}/lib" ||
		die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( {CHANGES,README,RELEASE}.txt )
	distutils-r1_python_install_all
	rm "${ED%/}/usr/bin/scons.bat" || die

	use doc && dodoc "${DISTDIR}"/${P}-user.{pdf,html}
}
