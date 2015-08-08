# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils fdo-mime toolchain-funcs
MY_P=${P/_}

DESCRIPTION="An amateur radio logging program"
HOMEPAGE="http://www.nongnu.org/xlog"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/hamlib
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.0.7-desktop.patch"

	# Let portage handle updating mime/desktop databases,
	epatch "${FILESDIR}/${PN}-2.0.13-desktop-update.patch"
	# Drop -Werror
	sed -i -e "s:-Werror::" configure.ac || die
	eautoreconf
}

src_configure() {
	# mime-update causes file collisions if enabled
	econf --disable-mime-update --disable-desktop-update \
		--docdir=/usr/share/doc/${PF}
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install
	docompress -x /usr/share/doc/${PF}/{KEYS,ChangeLog,TODO,BUGS}
	dodoc AUTHORS data/doc/THANKS NEWS README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
