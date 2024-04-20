# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="TCP daemon and set of libraries for usbredir protocol (redirecting USB traffic)"
HOMEPAGE="https://www.spice-space.org/usbredir.html https://gitlab.freedesktop.org/spice/usbredir"
SRC_URI="https://gitlab.freedesktop.org/spice/usbredir/-/archive/${P}/${PN}-${P}.tar.bz2"
S="${WORKDIR}"/usbredir-${P}

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/glib:2
	virtual/libusb:1
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# This overrides our toolchain default.
	sed -i -e '/-D_FORTIFY_SOURCE=2/d' meson.build || die

	local emesonargs=(
		-Dgit_werror=disabled
		$(meson_feature test tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc -r docs/.
}
