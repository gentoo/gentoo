# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop perl-module

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="https://slic3r.org"
SRC_URI="https://github.com/alexrj/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gui test"
RESTRICT="!test? ( test )"

# check Build.PL for dependencies
RDEPEND="!=dev-lang/perl-5.16*
	>=dev-libs/boost-1.73[threads(+)]
	dev-perl/Class-XSAccessor
	dev-perl/Devel-CheckLib
	dev-perl/Devel-Size
	>=dev-perl/Encode-Locale-1.50.0
	dev-perl/IO-stringy
	>=dev-perl/Math-PlanePath-53.0.0
	>=dev-perl/Moo-1.3.1
	dev-perl/XML-SAX-ExpatXS
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-parent
	virtual/perl-Scalar-List-Utils
	virtual/perl-Test-Simple
	virtual/perl-Thread-Semaphore
	>=virtual/perl-threads-1.960.0
	virtual/perl-Time-HiRes
	virtual/perl-Unicode-Normalize
	virtual/perl-XSLoader
	gui? ( dev-perl/Class-Accessor
		dev-perl/Growl-GNTP
		dev-perl/libwww-perl
		dev-perl/Module-Pluggable
		dev-perl/Net-Bonjour
		dev-perl/Net-DBus
		dev-perl/OpenGL
		>=dev-perl/Wx-0.991.800
		dev-perl/Wx-GLCanvas
		>=media-libs/freeglut-3
		virtual/perl-Math-Complex
		>=virtual/perl-Socket-2.16.0
		x11-libs/libXmu
	)"
DEPEND="${RDEPEND}
	dev-libs/clipper
	dev-perl/Devel-CheckLib
	>=dev-perl/ExtUtils-CppGuess-0.70.0
	>=dev-perl/ExtUtils-Typemaps-Default-1.50.0
	>=dev-perl/ExtUtils-XSpp-0.170.0
	>=dev-perl/Module-Build-0.380.0
	>=dev-perl/Module-Build-WithXSpp-0.140.0
	>=virtual/perl-ExtUtils-MakeMaker-6.800.0
	>=virtual/perl-ExtUtils-ParseXS-3.220.0
	test? (	virtual/perl-Test-Harness
		virtual/perl-Test-Simple )"

S="${WORKDIR}/Slic3r-${PV}"
PERL_S="${S}/xs"

PATCHES=(
	"${FILESDIR}/${P}-boost-1.73.patch"
	"${FILESDIR}/${P}-no-locallib.patch"
	"${FILESDIR}/${P}-use-system-clipper.patch"
	"${FILESDIR}/${P}-wayland.patch"
)

src_prepare() {
	sed -i lib/Slic3r.pm -e "s@FindBin::Bin@FindBin::RealBin@g" || die
	perl-module_src_prepare
}

src_configure() {
	cd "${PERL_S}" || die
	SLIC3R_NO_AUTO=1 perl-module_src_configure
}

src_test() {
	cd "${PERL_S}" || die
	perl-module_src_test
}

src_install() {
	cd "${PERL_S}" || die
	perl-module_src_install

	pushd .. || die
	insinto "${VENDOR_LIB}"
	doins -r lib/Slic3r.pm lib/Slic3r

	insinto "${VENDOR_LIB}"/Slic3r
	doins -r var

	exeinto "${VENDOR_LIB}"/Slic3r
	doexe slic3r.pl

	dosym "${VENDOR_LIB}/Slic3r/slic3r.pl" "${EPREFIX}/usr/bin/slic3r.pl"

	make_desktop_entry "slic3r.pl --gui %F" \
		Slic3r \
		"${VENDOR_LIB}/Slic3r/var/Slic3r_128px.png" \
		"Graphics;3DGraphics;Engineering;Development"
	popd || die
}
