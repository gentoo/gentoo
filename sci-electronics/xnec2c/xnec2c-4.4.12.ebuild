# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg-utils

MY_P=${PN}-v${PV}

DESCRIPTION="A GTK+ graphical interactive version of nec2c"
HOMEPAGE="https://www.xnec2c.org"
SRC_URI="https://www.xnec2c.org/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	sys-devel/gettext"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply_user
	eautoreconf
}
src_install() {
	default
	docompress -x /usr/share/man

	rm -R "${D}/usr/share/doc/${P}" || die
	dodoc AUTHORS README.md doc/*.txt
	use doc && dodoc -r doc/*.html doc/images

	if ! use examples ; then
		rm -R "${D}/usr/share/${PN}/examples" || die
	fi
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	xdg_desktop_database_update
}
