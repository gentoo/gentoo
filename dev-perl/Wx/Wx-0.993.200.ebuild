# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"
DIST_AUTHOR=MDOOTSON
DIST_VERSION=0.9932
DIST_EXAMPLES=("samples/*")
inherit wxwidgets virtualx perl-module

DESCRIPTION="Perl bindings for wxGTK"
HOMEPAGE="http://wxperl.sourceforge.net/ ${HOMEPAGE}"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Alien-wxWidgets-0.670.0
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

src_prepare() {
	need-wxwidgets base-unicode
	perl-module_src_prepare
}

src_test() {
	# the webview/t/03_threads.t test tends to hang or crash in weird
	# ways depending on local configuration. eg, backtraces involving
	# all of webkit-gtk, kpartsplugin and kdelibs...
	perl_rm_files t/12_pod.t ext/webview/t/03_threads.t
	virtx perl-module_src_test
}
