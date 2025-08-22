# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Streaming-capable SipHash Implementation"
HOMEPAGE="
	https://c-util.github.io/c-siphash/
	https://github.com/c-util/c-siphash/
"
SRC_URI="
	https://github.com/c-util/c-siphash/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( Apache-2.0 LGPL-2.1+ )"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv"

DEPEND="
	>=dev-libs/c-stdaux-1.5.0
"
BDEPEND="
	virtual/pkgconfig
"

src_install() {
	meson_src_install

	# upstream c-util tends to force static libs due to optimizing for
	# subprojects usage.
	#
	# https://github.com/c-util/c-utf8/issues/8
	rm "${ED}"/usr/$(get_libdir)/libcsiphash-1.a || die
}
