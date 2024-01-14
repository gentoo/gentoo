# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Common files for development of Gnome packages"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-common"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

src_configure() {
	# Force people to rely on dev-build/autoconf-archive, bug #594084
	gnome2_src_configure --with-autoconf-archive
}
