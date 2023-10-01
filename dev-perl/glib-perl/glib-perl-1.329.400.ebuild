# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME=Glib
DIST_AUTHOR=XAOC
DIST_VERSION=1.3294
inherit perl-module

DESCRIPTION="Glib - Perl wrappers for the GLib utility and Object libraries"
HOMEPAGE="https://gtk2-perl.sf.net/ https://metacpan.org/release/Glib https://gitlab.gnome.org/GNOME/perl-glib"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2
"
DEPEND="${RDEPEND}"
# Log::Agent optional by Storable but has caused unexplained segv's
# from build/doc.pl: https://bugs.gentoo.org/529080
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-Depends-0.300.0
	>=dev-perl/ExtUtils-PkgConfig-1.0.0
	virtual/pkgconfig
	dev-perl/Log-Agent
"
