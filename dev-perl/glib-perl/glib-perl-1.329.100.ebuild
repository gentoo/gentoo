# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_NAME=Glib
DIST_AUTHOR=XAOC
DIST_VERSION=1.3291
inherit perl-module

DESCRIPTION="Glib - Perl wrappers for the GLib utility and Object libraries"
HOMEPAGE="http://gtk2-perl.sf.net/ https://metacpan.org/release/Glib"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2
"
# Log::Agent optional by Storable but has caused unexplained segv's
# from build/doc.pl : https://bugs.gentoo.org/529080
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-Depends-0.300.0
	>=dev-perl/ExtUtils-PkgConfig-1.0.0
	virtual/pkgconfig
	dev-perl/Log-Agent
"
