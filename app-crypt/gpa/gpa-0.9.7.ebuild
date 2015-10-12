# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The GNU Privacy Assistant (GPA) is a graphical user interface for GnuPG"
HOMEPAGE="http://gpa.wald.intevation.org"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE_LINGUAS=" ar cs de es fr ja nl pl pt_BR ru sv tr zh_TW"
IUSE="nls ${IUSE_LINGUAS// / linguas_}"

RDEPEND=">=x11-libs/gtk+-2.10.0:2
	>=dev-libs/libgpg-error-1.4
	>=dev-libs/libassuan-1.1.0
	>=app-crypt/gnupg-2
	>=app-crypt/gpgme-1.5.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i 's/Application;//' gpa.desktop
}

src_configure() {
	econf \
		--with-gpgme-prefix=/usr \
		--with-libassuan-prefix=/usr \
		$(use_enable nls) \
		GPGKEYS_LDAP="/usr/libexec/gpgkeys_ldap"
}
