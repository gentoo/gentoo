# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools epatch

DESCRIPTION="A top like console network traffic visualiser"
HOMEPAGE="http://jnettop.kubs.info/"
SRC_URI="http://jnettop.kubs.info/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="berkdb ncurses syslog"

RDEPEND="
	net-libs/libpcap
	>=dev-libs/glib-2.0.1
	berkdb? ( =sys-libs/db-4* )
	ncurses? ( sys-libs/ncurses )
	syslog? ( virtual/logger )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-asneeded.patch" \
		"${FILESDIR}/${P}-tinfo.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_with ncurses) \
		$(use_with berkdb db4) \
		$(use_with syslog)
}

src_install() {
	default
	newdoc .${PN} ${PN}.dotfile
}
