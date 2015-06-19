# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vile/vile-9.8n.ebuild,v 1.2 2015/03/31 17:33:30 ulm Exp $

EAPI="5"

DESCRIPTION="VI Like Emacs -- yet another full-featured vi clone"
HOMEPAGE="http://invisible-island.net/vile/"
SRC_URI="ftp://invisible-island.net/vile/current/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="perl"

RDEPEND=">=sys-libs/ncurses-5.2
	perl? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	sys-devel/flex
	app-eselect/eselect-vi"

src_configure() {
	econf \
		--with-ncurses \
		$(use_with perl )
}

src_install() {
	emake DESTDIR="${D}" INSTALL_OPTS="" install
	dodoc CHANGES* README doc/*.doc
	dohtml doc/*.html
}

pkg_postinst() {
	einfo "Updating ${EPREFIX}/usr/bin/vi symlink"
	eselect vi update --if-unset
}

pkg_postrm() {
	einfo "Updating ${EPREFIX}/usr/bin/vi symlink"
	eselect vi update --if-unset
}
