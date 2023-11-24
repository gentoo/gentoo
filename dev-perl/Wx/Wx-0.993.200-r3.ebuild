# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
DIST_AUTHOR=MDOOTSON
DIST_VERSION=0.9932
DIST_EXAMPLES=("samples/*")
inherit wxwidgets virtualx perl-module

DESCRIPTION="Perl bindings for wxGTK"
HOMEPAGE="https://wxperl.sourceforge.net/ https://metacpan.org/release/Wx"
SRC_URI="${SRC_URI}
	https://dev.gentoo.org/~pacho/${PN}/${P}-wx32-port.patch"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Alien-wxWidgets-0.690.0-r1
	x11-libs/wxGTK:${WX_GTK_VER}
	>=virtual/perl-File-Spec-0.820.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	>=virtual/perl-ExtUtils-ParseXS-3.150.0
	>=dev-perl/ExtUtils-XSpp-0.160.200
	>=virtual/perl-if-0.30.0
	test? (
		>=virtual/perl-Test-Harness-2.260.0
		>=virtual/perl-Test-Simple-0.430.0
	)
"
BDEPEND="${DEPEND}
	app-text/dos2unix
"

PATCHES=(
	# wxGTK-3.2 port from Fedora
	"${FILESDIR}"/${P}-gtk3.patch
	"${FILESDIR}"/${P}-wx32-makemaker.patch
	"${DISTDIR}"/${P}-wx32-port.patch
)

src_prepare() {
	# Fix line endings
	dos2unix MANIFEST || die
	dos2unix typemap || die

	setup-wxwidgets
	perl-module_src_prepare
}

src_test() {
	# the webview/t/03_threads.t test tends to hang or crash in weird
	# ways depending on local configuration. eg, backtraces involving
	# all of webkit-gtk, kpartsplugin and kdelibs...
	perl_rm_files t/12_pod.t ext/webview/t/03_threads.t
	virtx perl-module_src_test
}
