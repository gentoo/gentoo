# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DESCRIPTION="skarnet.org general-purpose libraries"
HOMEPAGE="https://www.skarnet.org/software/skalibs/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc ipv6 static-libs"

DEPEND=">=sys-devel/make-3.81"
RDEPEND=""

HTML_DOCS="doc/*"

src_prepare() {
	default

	# Remove QA warning about LDFLAGS addition
	sed -i "s/tryldflag LDFLAGS_AUTO -Wl,--hash-style=both/:/" "${S}/configure" || die
}

src_configure() {
	econf \
		--datadir=/etc \
		--dynlibdir=/$(get_libdir) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--sysdepdir=/usr/$(get_libdir)/${PN} \
		--enable-clock \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable ipv6)
}

src_install() {
	emake DESTDIR="${D}" install

	use doc && einstalldocs
}
