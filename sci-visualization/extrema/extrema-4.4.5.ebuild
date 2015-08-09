# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
WX_GTK_VER="2.8"
inherit eutils fdo-mime wxwidgets

DESCRIPTION="Interactive data analysis and visualization tool"
HOMEPAGE="http://exsitewebware.com/extrema/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

# File collision, see bug #249423
RDEPEND="!sci-chemistry/psi
	x11-libs/wxGTK:2.8[X]
	dev-util/desktop-file-utils"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e 's/$(pkgdatadir)/$(DESTDIR)$(pkgdatadir)/g' \
		src/Makefile.in || die
	epatch "${FILESDIR}"/${P}-gcc46.patch
}

src_configure() {
	# extrema cannot be compiled with versions of minuit
	# available in portage
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default
	make_desktop_entry ${PN}
	dodir /usr/share/icons/hicolor
	tar xjf extrema_icons.tar.bz2 -C "${ED}usr/share/icons/hicolor"
	dosym ../../icons/hicolor/48x48/apps/extrema.png /usr/share/pixmaps/extrema.png

	use doc && dodoc doc/*.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins Scripts/*.pcm Scripts/*.dat || die
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
