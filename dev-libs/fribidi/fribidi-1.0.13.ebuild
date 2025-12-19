# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A free implementation of the unicode bidirectional algorithm"
HOMEPAGE="https://fribidi.org/"
SRC_URI="https://github.com/fribidi/fribidi/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local emesonargs=(
		-Ddeprecated=true
		$(meson_native_use_bool doc docs)
		-Dbin=true
		$(meson_use test tests)
	)
	meson_src_configure
}
