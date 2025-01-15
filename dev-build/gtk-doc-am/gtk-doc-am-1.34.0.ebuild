# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="gtk-doc"

inherit gnome.org

DESCRIPTION="Automake files from gtk-doc"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gtk-doc"

LICENSE="GPL-2+ FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="!<dev-util/gtk-doc-${PV}"
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
