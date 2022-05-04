# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Rules for polkit to add compatibility with pklocalauthority"
HOMEPAGE="https://pagure.io/polkit-pkla-compat"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

RDEPEND="
	acct-group/polkitd
	>=dev-libs/glib-2.30
	>=sys-auth/polkit-0.110"
DEPEND="${RDEPEND}"
BDEPEND="
	acct-group/polkitd
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig"

src_configure() {
	econf --localstatedir="${EPREFIX}/var"
}

src_install() {
	default
	keepdir /etc/polkit-1/localauthority.conf.d
	keepdir /{etc,var/lib}/polkit-1/localauthority/{10-vendor.d,20-org.d,30-site.d,50-local.d,90-mandatory.d}
}
