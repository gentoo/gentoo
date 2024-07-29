# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Virtual Common Access Card (CAC) library emulator"
HOMEPAGE="https://gitlab.freedesktop.org/spice/libcacard https://www.spice-space.org/"
SRC_URI="https://www.spice-space.org/download/libcacard/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="+passthrough static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/nss-3.12.8
	>=dev-libs/glib-2.32
	passthrough? ( >=sys-apps/pcsc-lite-1.8 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		$(meson_feature passthrough pcsc)
		$(meson_use !test disable_tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	dodoc docs/*.txt
}
