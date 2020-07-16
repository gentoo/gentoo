# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 perl-module

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="https://slic3r.org"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Slic3r/Slic3r.git"

LICENSE="AGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS=""
IUSE="+gui test"
RESTRICT="!test? ( test )"

# check Build.PL for dependencies
RDEPEND="!=dev-lang/perl-5.16*
	>=dev-libs/boost-1.55[threads]
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

S="${WORKDIR}/slic3r-${PV}/xs"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	pushd "${WORKDIR}/slic3r-${PV}" || die
	sed -i lib/Slic3r.pm -e "s@FindBin::Bin@FindBin::RealBin@g" || die
	eapply "${FILESDIR}"/${P}-no-locallib.patch
	eapply_user
	popd || die
}

src_configure() {
	SLIC3R_NO_AUTO=1 perl-module_src_configure
}

src_test() {
	perl-module_src_test
	pushd .. || die
	prove -Ixs/blib/arch -Ixs/blib/lib/ t/ || die "Tests failed"
	popd || die
}

src_install() {
	perl-module_src_install

	pushd .. || die
	insinto "${VENDOR_LIB}"
	doins -r lib/Slic3r.pm lib/Slic3r

	insinto "${VENDOR_LIB}"/Slic3r
	doins -r var

	exeinto "${VENDOR_LIB}"/Slic3r
	doexe slic3r.pl

	dosym "${VENDOR_LIB}"/Slic3r/slic3r.pl /usr/bin/slic3r.pl

	make_desktop_entry slic3r.pl \
		Slic3r \
		"${VENDOR_LIB}/Slic3r/var/Slic3r_128px.png" \
		"Graphics;3DGraphics;Engineering;Development"
	popd || die
}
