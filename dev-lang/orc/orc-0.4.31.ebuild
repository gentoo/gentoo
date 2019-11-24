# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal

DESCRIPTION="The Oil Runtime Compiler, a just-in-time compiler for array operations"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
RESTRICT="!test? ( test )"
IUSE="static-libs test"

DEPEND=""
RDEPEND=""

multilib_src_configure() {
	# FIXME: handle backends per arch? What about cross-compiling for the other arches?
	local emesonargs=(
		$(meson_feature test tests)
		-Ddefault_library=$(usex static-libs both shared)
		-Dorc-backend=all
		-Dbenchmarks=disabled
		-Dexamples=disabled
		-Dgtk_doc=disabled
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
