# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sulfur/sulfur-1.0_rc104-r1.ebuild,v 1.1 2014/12/15 05:22:07 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils fdo-mime python-single-r1

DESCRIPTION="Sulfur, the Entropy Package Manager Store"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/app-admin/sulfur-${PV}.tar.bz2"

RDEPEND="dev-python/pygtk:2[${PYTHON_USEDEP}]
	>=sys-apps/entropy-${PV}[${PYTHON_USEDEP}]
	sys-apps/file[python,${PYTHON_USEDEP}]
	sys-devel/gettext
	x11-libs/vte:0[python,${PYTHON_USEDEP}]
	x11-misc/xdg-utils"
DEPEND="sys-devel/gettext"

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="usr/lib" install || die "make install failed"
	dodir /etc/gconf/schemas
	insinto /etc/gconf/schemas
	doins "${S}/misc/entropy-handler.schemas"

	python_fix_shebang "${ED}"
	python_optimize "${ED%/}"/usr/lib/entropy
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	gnome2_gconf_savelist
	gnome2_gconf_install
}

pkg_postrm() {
	gnome2_gconf_savelist
	gnome2_gconf_uninstall
}
