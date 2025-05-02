# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common java-pkg-opt-2

MY_P=ThePEG-${PV}

DESCRIPTION="Toolkit for High Energy Physics Event Generation"
HOMEPAGE="https://thepeg.hepforge.org/"

TEST_URI="https://www.hepforge.org/downloads/lhapdf/pdfsets/current"
SRC_URI="https://www.hepforge.org/downloads/thepeg/${MY_P}.tar.bz2
	test? ( hepmc? (
		${TEST_URI}/cteq6ll.LHpdf
		${TEST_URI}/cteq5l.LHgrid
		${TEST_URI}/GRV98nlo.LHgrid
		${TEST_URI}/MRST2001nlo.LHgrid ) )"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0/20"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs fastjet hepmc lhapdf static-libs test zlib"
RESTRICT="!test? ( test )"

CDEPEND="
	sci-libs/gsl:0=
	emacs? ( >=app-editors/emacs-23.1:* )
	fastjet? ( sci-physics/fastjet:0= )
	hepmc? ( sci-physics/hepmc:2= )
	lhapdf? ( >=sci-physics/lhapdf-6.0:0= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.8:*[-headless-awt] )
	test? ( sys-process/time )"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.8:* )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.3-java.patch # there are todo items in the patch
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
	if use java; then
		local -x JAVAC="$(java-pkg_get-javac)"
		local -x JAVA="$(java-config -J)"
		local -x JAR="$(java-config -j)"
		local -x JAVAC_SOURCE="$(java-pkg_get-source)"
		local -x JAVAC_TARGET="$(java-pkg_get-target)"
	fi
	econf \
		$(use_enable static-libs static) \
		$(use_with fastjet fastjet "${EPREFIX}"/usr) \
		$(use_with hepmc hepmc "${EPREFIX}"/usr) \
		$(use_with hepmc hepmcversion 2) \
		$(use_with java javagui) \
		$(use_with lhapdf lhapdf "${EPREFIX}"/usr) \
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
