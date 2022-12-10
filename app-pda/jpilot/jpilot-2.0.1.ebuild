# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV="${PV//./_}"

DESCRIPTION="Desktop Organizer Software for the Palm Pilot"
HOMEPAGE="http://www.jpilot.org/ https://github.com/juddmon/jpilot/"
SRC_URI="https://github.com/juddmon/jpilot/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
IUSE="nls"

RDEPEND="
	app-pda/pilot-link
	dev-libs/libgcrypt:0=
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.2-qa-desktop-file.patch
	"${FILESDIR}"/${PN}-1.8.2-fix-paths.patch
	"${FILESDIR}"/${P}-fix-configure-clang16.patch
	"${FILESDIR}"/${P}-fix-lto-type-mismatch.patch
)

src_prepare() {
	default
	sed -i -e 's|_UNQUOTED(ABILIB, "lib"|_UNQUOTED(ABILIB, "'$(get_libdir)'"|' configure.in || die
	eautoreconf
}

src_configure() {
	econf $(use_enable nls) --with-pilot_prefix=/usr/include/libpisock/
}

src_install() {
	default
	docompress -x /usr/share/doc/${PF}/icons

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
