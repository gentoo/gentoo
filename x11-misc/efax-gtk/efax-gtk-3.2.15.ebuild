# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A graphical frontend for the 'efax' application"
HOMEPAGE="http://efax-gtk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tgz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"

RDEPEND="
	>=dev-libs/glib-2.10
	media-libs/tiff:0=
	x11-libs/libX11
	x11-libs/c++-gtk-utils:0[gtk]
	x11-libs/gtk+:3
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
"

DOCS="AUTHORS BUGS ChangeLog README"

src_prepare() {
	default
	# Prevent sandbox violation with chown/chgrp and existing spooldir
	sed -i -e '/ch.*lp.*spooldir/d' efax-gtk-faxfilter/Makefile.in || die

	sed -i \
		-e '/^Categories/s:Office;::' \
		${PN}.desktop || die
}

src_configure() {
	econf \
		--with-gtk-version=gtk3
}

src_install() {
	default
	# File collision with net-misc/efax wrt #401221
	mv "${ED}"/usr/share/man/man1/efax{,-0.9a}.1 || die
	mv "${ED}"/usr/share/man/man1/efix{,-0.9a}.1 || die
}

pkg_postinst() {
	local spooldir="${EROOT}"/var/spool/fax
	[[ -d ${spooldir} ]] && chown lp:lp "${spooldir}"
}
