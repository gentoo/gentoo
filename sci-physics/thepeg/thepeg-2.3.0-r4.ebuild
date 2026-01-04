# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=ThePEG-${PV}
inherit autotools elisp-common java-pkg-opt-2

DESCRIPTION="Toolkit for High Energy Physics Event Generation"
HOMEPAGE="https://thepeg.hepforge.org/"

TEST_URI="https://www.hepforge.org/downloads/lhapdf/pdfsets/current"
SRC_URI="https://www.hepforge.org/downloads/thepeg/${MY_P}.tar.bz2
	test? (
		hepmc3? (
			${TEST_URI}/cteq6ll.LHpdf
			${TEST_URI}/cteq5l.LHgrid
			${TEST_URI}/GRV98nlo.LHgrid
			${TEST_URI}/MRST2001nlo.LHgrid )
	)"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0/30"
KEYWORDS="~amd64"
IUSE="emacs fastjet +hepmc3 lhapdf rivet static-libs test zlib"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	sci-libs/gsl:0=
	emacs? ( >=app-editors/emacs-23.1:* )
	fastjet? ( sci-physics/fastjet:0= )
	rivet? (
		>=sci-physics/rivet-3.1.11-r1:=[hepmc3(+)]
		<sci-physics/rivet-4:=
	)
	hepmc3? ( sci-physics/hepmc:3= )
	lhapdf? ( >=sci-physics/lhapdf-6.0:0= )
	zlib? ( virtual/zlib:= )
"
DEPEND="${COMMON_DEPEND}
	sci-libs/gsl:=
	java? ( >=virtual/jdk-1.8:*[-headless-awt] )
	test? (
		sys-process/time
		dev-libs/boost
	)
"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.4-gcc6.patch
	"${FILESDIR}"/${PN}-2.3.0-rivet.patch # properly support rivet/yoda weights in thepeg, reported to upstream by mail.
	"${FILESDIR}"/${PN}-2.3.0-functional.patch # https://bugs.gentoo.org/941477
	"${FILESDIR}"/${PN}-2.2.3-java.patch
)

src_prepare() {
	find -name 'Makefile.am' -exec \
		sed -i -e '1ipkgdatadir=$(datadir)/ThePEG' {} \; || die
	# trick to force c++ linking
	sed -i \
		-e '1inodist_EXTRA_libThePEG_la_SOURCES = dummy.cxx' \
		-e '/dist_pkgdata_DATA = ThePEG.el/d' \
		lib/Makefile.am || die
	default
	if use java; then
		sed -i "s/JAVA_PKG_GET_SOURCE/$(java-pkg_get-source)/g" configure.ac java/Makefile.am || die
		sed -i "s/JAVA_PKG_GET_TARGET/$(java-pkg_get-target)/g" configure.ac java/Makefile.am || die
	fi
	java-pkg-opt-2_src_prepare
	eautoreconf
}

src_configure() {
	local -x CONFIG_SHELL=/bin/bash
	if use java; then
		local -x JAVAC="$(java-pkg_get-javac)"
		local -x JAVA="$(java-config -J)"
		local -x JAR="$(java-config -j)"
		local -x JAVAC_SOURCE="$(java-pkg_get-source)"
		local -x JAVAC_TARGET="$(java-pkg_get-target)"
	fi
	econf \
		$(use_enable static-libs static) \
		$(use_with fastjet fastjet "${ESYSROOT}"/usr) \
		$(use_with hepmc3 hepmc "${ESYSROOT}"/usr) \
		$(use_with hepmc3 hepmcversion 3) \
		$(use_with java javagui) \
		$(use_with lhapdf lhapdf "${ESYSROOT}"/usr) \
		$(use_with test boost "${ESYSROOT}"/usr) \
		$(use_with rivet rivet "${ESYSROOT}"/usr) \
		$(use_with zlib zlib "${ESYSROOT}"/usr)
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

	cat <<-EOF > "${T}"/50${PN} || die
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
