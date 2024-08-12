# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/gtk-engines-}"
MY_PV="${PV/_pre/+14.04.}"
MY_P="${MY_PN}_${MY_PV}"
inherit autotools multilib-minimal

DESCRIPTION="The Unico GTK+ 3.x theming engine"
HOMEPAGE="https://launchpad.net/unico"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${MY_P}.orig.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.26:2[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.10[glib,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.5.2:3[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.3_pre20140109-slibtool-lm.patch
)

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	# $(use_enable debug) controls CPPFLAGS -D_DEBUG and -DNDEBUG but they are currently
	# unused in the code itself.
	local myeconfargs=(
		--disable-static
		--disable-debug
		--disable-maintainer-flags
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
