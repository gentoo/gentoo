# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PERLMAX
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl binding for GooCanvas2 widget using Glib::Object::Introspection"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	x11-libs/goocanvas:2.0[introspection]
	dev-perl/Gtk3
"
BDEPEND="${RDEPEND}"
DEPEND="
	x11-libs/goocanvas:2.0[introspection]
"
