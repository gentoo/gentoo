# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="The Oil Runtime Compiler, a just-in-time compiler for array operations"
HOMEPAGE="https://gstreamer.freedesktop.org/ https://gitlab.freedesktop.org/gstreamer/orc"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86 ~x64-macos ~x64-solaris"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

# in orc-0.4.42 upstream dropped gtk-doc in favour of hotdoc, which isn't widely
# packaged yet. This means we have no docs, presently.

DOCS=( CONTRIBUTING.md README RELEASE )

multilib_src_configure() {
	# FIXME: handle backends per arch? What about cross-compiling for the other arches?
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Dorc-target=all
		-Dorc-test=enabled
		-Dbenchmarks=disabled
		-Dexamples=disabled
		$(meson_feature test tests)
		-Dtools=enabled # requires orc-test
	)
	meson_src_configure
}
