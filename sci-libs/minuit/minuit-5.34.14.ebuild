# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A C++ physics analysis tool for function minimization"
HOMEPAGE="https://seal.web.cern.ch/seal/snapshot/work-packages/mathlibs/minuit/"
SRC_URI="
	http://www.cern.ch/mathlibs/sw/${PV//./_}/${PN^}2/${PN^}2-5.34.14.tar.gz -> ${P}.tar.gz
	doc? (
		http://seal.cern.ch/documents/minuit/mnusersguide.pdf
		http://seal.cern.ch/documents/minuit/mntutorial.pdf
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc openmp static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}/${PN^}2-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-5.27.02-asneeded.patch )

src_prepare() {
	default
	rm config/m4/ac_openmp.m4 || die
	mv configure.{in,ac} || die

	AT_M4DIR="config/m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable openmp)
}

src_compile() {
	default
	use doc && emake docs
}

src_test() {
	emake check

	cd test/MnTutorial || die
	local t
	for t in test_*; do
			./${t} || die "${t} failed"
	done
}

src_install() {
	if use doc; then
		# remove doxygen junk
		find doc/html \( -iname '*.map' -o -iname '*.md5' \) -delete || die
		HTML_DOCS=( doc/html/. )
		dodoc "${DISTDIR}"/mn{usersguide,tutorial}.pdf
	fi
	default

	docinto examples
	dodoc test/MnTutorial/*.{h,cxx}
	docompress -x /usr/share/doc/${PF}/examples

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
