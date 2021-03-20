# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="XKB keyboard description compiler"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""
DEPEND="
	>=x11-libs/libX11-1.6.9
	x11-libs/libxkbfile"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/bison"
