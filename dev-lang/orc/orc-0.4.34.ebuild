# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="The Oil Runtime Compiler, a just-in-time compiler for array operations"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
RESTRICT="!test? ( test )"
IUSE="gtk-doc static-libs test"

BDEPEND="
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.3
	)
"

multilib_src_configure() {
	# FIXME: handle backends per arch? What about cross-compiling for the other arches?
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Dorc-backend=all
		-Dorc-test=enabled
		-Dbenchmarks=disabled
		-Dexamples=disabled
		$(meson_native_use_feature gtk-doc gtk_doc)
		$(meson_feature test tests)
		-Dtools=enabled # requires orc-test
	)
	meson_src_configure
}
