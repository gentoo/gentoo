# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="MIME data for Gnome"
HOMEPAGE="https://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

BDEPEND="
	virtual/pkgconfig
	>=dev-util/intltool-0.35"

src_prepare() {
	intltoolize --force || die "intltoolize failed"
	gnome2_src_prepare
}
