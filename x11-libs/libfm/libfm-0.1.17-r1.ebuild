# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils fdo-mime

DESCRIPTION="A library for file management"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

KEYWORDS="~alpha amd64 arm ppc x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug examples udev"

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.16:2
	udev? ( dev-libs/dbus-glib )
	>=lxde-base/menu-cache-0.3.2"
RDEPEND="${COMMON_DEPEND}
	x11-misc/shared-mime-info
	udev? ( sys-fs/udisks:0 )"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	sed -ie '/SUBDIRS=/s#docs##' "${S}"/Makefile.am || die "sed failed"
	sed -i -e '/^[[:space:]]*docs/d' -e "s:-O0::" -e "/-DG_ENABLE_DEBUG/s: -g::" \
		configure.ac || die "sed failed"
	#Remove -Werror for automake-1.12. Bug #421101
	sed -i "s:-Werror::" configure.ac || die
	# Bug 409939
	epatch "${FILESDIR}"/${P}-ssp-fix.patch
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}/etc" \
		--disable-dependency-tracking \
		--disable-static \
		$(use_enable udev udisks) \
		$(use_enable examples demo) \
		$(use_enable debug) \
		# Documentation fails to build at the moment
		# $(use_enable doc gtk-doc) \
		# $(use_enable doc gtk-doc-html) \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f '{}' +
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
