# Copyright 1999-2017 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Desktop Organizer Software for the Palm Pilot"
HOMEPAGE="http://www.jpilot.org/"
SRC_URI="http://jpilot.org/tarballs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 x86"
IUSE="nls"

RDEPEND="
	app-pda/pilot-link
	dev-libs/libgcrypt:0=
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.2-qa-desktop-file.patch
	"${FILESDIR}"/${PN}-1.8.2-fix-paths.patch
)

src_prepare() {
	default
	sed -i -e 's|_UNQUOTED(ABILIB, "lib"|_UNQUOTED(ABILIB, "'$(get_libdir)'"|' configure.in || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	docompress -x /usr/share/doc/${PF}/icons

	# .la files for plugins are useless
	find "${D}" -name '*.la' -delete || die
}
