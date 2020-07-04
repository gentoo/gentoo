# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils elisp-common eutils java-pkg-opt-2

MYP=ThePEG-${PV}

DESCRIPTION="Toolkit for High Energy Physics Event Generation"
HOMEPAGE="http://home.thep.lu.se/ThePEG/"

TEST_URI="http://www.hepforge.org/archive/lhapdf/pdfsets/current"
SRC_URI="http://www.hepforge.org/archive/thepeg/${MYP}.tar.bz2
	test? ( hepmc? (
	   ${TEST_URI}/cteq6ll.LHpdf
	   ${TEST_URI}/cteq5l.LHgrid
	   ${TEST_URI}/GRV98nlo.LHgrid
	   ${TEST_URI}/MRST2001nlo.LHgrid ) )"
LICENSE="GPL-2"

SLOT="0/20"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="c++11 emacs fastjet hepmc java lhapdf rivet static-libs test zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/gsl:0=
	emacs? ( >=app-editors/emacs-23.1:* )
	fastjet? ( sci-physics/fastjet:0= )
	hepmc? ( sci-physics/hepmc:0= )
	java? ( >=virtual/jre-1.5:* )
	lhapdf? ( sci-physics/lhapdf:0= )
	rivet? ( sci-physics/rivet:0= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${RDEPEND}
	test? ( sys-process/time )"

S="${WORKDIR}/${MYP}"

PATCHES=( "${FILESDIR}"/${PN}-1.8.3-java.patch )

src_prepare() {
	find -name 'Makefile.am' -exec \
		sed -i -e '1ipkgdatadir=$(datadir)/thepeg' {} \; || die
	# trick to force c++ linking
	sed -i \
		-e '1inodist_EXTRA_libThePEG_la_SOURCES = dummy.cxx' \
		-e '/dist_pkgdata_DATA = ThePEG.el/d' \
		lib/Makefile.am || die
	autotools-utils_src_prepare
	java-pkg-opt-2_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable c++11 stdcxx11)
		$(use_with fastjet fastjet "${EPREFIX}"/usr)
		$(use_with hepmc hepmc "${EPREFIX}"/usr)
		$(use_with java javagui)
		$(use_with lhapdf lhapdf "${EPREFIX}"/usr)
		$(use_with rivet rivet "${EPREFIX}"/usr)
		$(use_with zlib zlib "${EPREFIX}"/usr)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use emacs && elisp-compile lib/ThePEG.el
}

src_test() {
	emake LHAPATH="${DISTDIR}" -C "${BUILD_DIR}" check
}

src_install() {
	autotools-utils_src_install
	use emacs && elisp-install ${PN} lib/ThePEG.el{,c}
	use java && java-pkg_newjar java/ThePEG.jar

	cat <<-EOF > "${T}"/50${PN}
	LDPATH="${EPREFIX}/usr/$(get_libdir)/ThePEG"
	EOF
	doenvd "${T}"/50${PN}
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
