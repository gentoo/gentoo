# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common java-pkg-opt-2

MY_P=ThePEG-${PV}

DESCRIPTION="Toolkit for High Energy Physics Event Generation"
HOMEPAGE="http://home.thep.lu.se/ThePEG/"

TEST_URI="https://www.hepforge.org/archive/lhapdf/pdfsets/current"
SRC_URI="https://www.hepforge.org/archive/thepeg/${MY_P}.tar.bz2
	test? ( hepmc3? (
		${TEST_URI}/cteq6ll.LHpdf
		${TEST_URI}/cteq5l.LHgrid
		${TEST_URI}/GRV98nlo.LHgrid
		${TEST_URI}/MRST2001nlo.LHgrid ) )"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0/30"
KEYWORDS="~amd64 ~x86"
IUSE="emacs fastjet +hepmc3 java lhapdf static-libs test zlib"
RESTRICT="!test? ( test )"

CDEPEND="
	sci-libs/gsl:0=
	emacs? ( >=app-editors/emacs-23.1:* )
	fastjet? ( sci-physics/fastjet:0= )
	hepmc3? ( sci-physics/hepmc:3= )
	lhapdf? ( >=sci-physics/lhapdf-6.0:0= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${CDEPEND}
	java? ( virtual/jdk:1.8 )
	test? (
		sys-process/time
		dev-libs/boost
	)"
RDEPEND="${CDEPEND}
	java? ( virtual/jre:1.8 )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.3-java.patch
	"${FILESDIR}"/${PN}-2.0.4-gcc6.patch
)

src_prepare() {
	find -name 'Makefile.am' -exec \
		sed -i -e '1ipkgdatadir=$(datadir)/thepeg' {} \; || die
	# trick to force c++ linking
	sed -i \
		-e '1inodist_EXTRA_libThePEG_la_SOURCES = dummy.cxx' \
		-e '/dist_pkgdata_DATA = ThePEG.el/d' \
		lib/Makefile.am || die
	default
	java-pkg-opt-2_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with fastjet fastjet "${EPREFIX}"/usr) \
		$(use_with hepmc3 hepmc "${EPREFIX}"/usr) \
		$(use_with hepmc3 hepmcversion 3) \
		$(use_with java javagui) \
		$(use_with lhapdf lhapdf "${EPREFIX}"/usr) \
		$(use_with test boost "${EPREFIX}"/usr) \
		--without-rivet \
		$(use_with zlib zlib "${EPREFIX}"/usr)
}

src_compile() {
	default
	use emacs && elisp-compile lib/ThePEG.el
}

src_test() {
	emake LHAPATH="${DISTDIR}" check
}

src_install() {
	default
	use emacs && elisp-install ${PN} lib/ThePEG.el{,c}
	use java && java-pkg_newjar java/ThePEG.jar

	cat <<-EOF > "${T}"/50${PN}
	LDPATH="${EPREFIX}/usr/$(get_libdir)/ThePEG"
	EOF
	doenvd "${T}"/50${PN}

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
