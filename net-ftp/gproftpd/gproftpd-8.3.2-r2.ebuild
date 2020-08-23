# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="GTK frontend to proftpd"
HOMEPAGE="https://mange.dynalias.org/linux/gproftpd"
SRC_URI="http://mange.dynup.net/linux/gproftpd/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
SLOT="0"

RDEPEND="
	>=dev-libs/atk-1.0
	>=media-libs/freetype-2.0
	>=x11-libs/pango-1.0
	dev-libs/glib:2
	virtual/libiconv
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-install.patch
)
DOCS="AUTHORS ChangeLog README"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	rm -r "${D}/usr/share/doc/gproftpd" || die
}

pkg_postinst() {
	elog "gproftpd looks for your proftpd.conf file in /etc/proftpd"
	elog "run gproftpd with the option -c to specify an alternate location"
	elog "ex: gproftpd -c /etc/proftpd.conf"
	elog "Do NOT edit /etc/conf.d/proftpd with this program"
}
