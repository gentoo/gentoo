# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="initctl Compatibility Daemon"
HOMEPAGE="https://github.com/systemd/systemd-initctl"
SRC_URI="https://github.com/systemd/systemd-initctl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="
	sys-apps/systemd:0=
"
RDEPEND="${DEPEND}
	!<sys-apps/systemd-258
"
BDEPEND="
	virtual/pkgconfig
"
