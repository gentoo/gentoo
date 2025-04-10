# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="${PN}-fonts"

inherit gnome.org meson

DESCRIPTION="GNOME Adwaita Fonts"
HOMEPAGE="https://gitlab.gnome.org/GNOME/adwaita-fonts"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="
	>=sys-devel/gettext-0.20
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"
