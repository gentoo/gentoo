# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A set of scripts and m4/autoconf macros that ease build system maintenance"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-dev-tools/start
	https://gitlab.xfce.org/xfce/xfce4-dev-tools/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"

DEPEND="
	>=dev-libs/glib-2.50
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
