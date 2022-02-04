# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="gtk-doc"

inherit gnome.org

DESCRIPTION="Automake files from gtk-doc"
HOMEPAGE="https://wiki.gnome.org/DocumentationProject/GtkDoc"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="!<dev-util/gtk-doc-${GNOME_ORG_PVP}"
PDEPEND="virtual/pkgconfig"

# This ebuild doesn't even compile anything, causing tests to fail when updating (bug #316071)
RESTRICT="test"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	insinto /usr/share/aclocal
	doins buildsystems/autotools/gtk-doc.m4
}
