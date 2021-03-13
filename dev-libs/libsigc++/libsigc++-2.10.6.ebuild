# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic gnome.org meson multilib-minimal

DESCRIPTION="Typesafe callback system for standard C++"
HOMEPAGE="https://libsigcplusplus.github.io/libsigcplusplus/
	https://github.com/libsigcplusplus/libsigcplusplus"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/boost[${MULTILIB_USEDEP}] )"
BDEPEND="sys-devel/m4
	doc? ( app-doc/doxygen[dot] )"

multilib_src_configure() {
	filter-flags -fno-exceptions #84263

	local -a emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Dbenchmark=$(usex test true false)
		-Dbuild-documentation=$(multilib_native_usex doc true false)
		-Dbuild-examples=false
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	einstalldocs

	# Note: html docs are installed into /usr/share/doc/libsigc++-2.0
	# We can't use /usr/share/doc/${PF} because of links from glibmm etc. docs
	if use doc; then
		docinto examples
		dodoc examples/*.cc
	fi
}
