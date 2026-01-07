# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org flag-o-matic meson-multilib

DESCRIPTION="Typesafe callback system for standard C++"
HOMEPAGE="https://libsigcplusplus.github.io/libsigcplusplus/
	https://github.com/libsigcplusplus/libsigcplusplus"
SRC_URI="https://github.com/libsigcplusplus/libsigcplusplus/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="gtk-doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	gtk-doc? (
		app-text/doxygen[dot]
		dev-lang/perl
		dev-libs/libxslt
	)
"

multilib_src_configure() {
	filter-flags -fno-exceptions #84263

	local emesonargs=(
		-Dbuild-examples=false
		$(meson_native_use_bool gtk-doc build-documentation)
		$(meson_use test build-tests)
	)
	meson_src_configure
}

multilib_src_install_all() {
	# Note: html docs are installed into /usr/share/doc/libsigc++-3.0
	# We can't use /usr/share/doc/${PF} because of links from glibmm etc. docs
	:;
}
