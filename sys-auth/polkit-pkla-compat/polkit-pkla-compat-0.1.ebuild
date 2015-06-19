# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit-pkla-compat/polkit-pkla-compat-0.1.ebuild,v 1.2 2014/03/07 14:24:04 ssuominen Exp $

EAPI=5

DESCRIPTION="Rules for polkit to add compatibility with pklocalauthority"
HOMEPAGE="http://fedorahosted.org/polkit-pkla-compat/"
SRC_URI="http://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.30
	>=sys-auth/polkit-0.110"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig"

DOCS="AUTHORS NEWS README"

src_install() {
	default
	fowners -R root:polkitd /etc/polkit-1/localauthority
}

pkg_postinst() {
	chown -R root:polkitd "${EROOT}"/etc/polkit-1/localauthority
}
