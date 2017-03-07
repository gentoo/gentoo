# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The GNU Privacy Assistant (GPA) is a graphical user interface for GnuPG"
HOMEPAGE="http://gpa.wald.intevation.org"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE_LINGUAS=" ar cs de es fr ja nl pl pt_BR ru sv tr zh_TW"
IUSE="nls ${IUSE_LINGUAS// / linguas_}"

RDEPEND="
	>=app-crypt/gnupg-2:=
	>=app-crypt/gpgme-1.5.0:=
	>=dev-libs/libassuan-1.1.0
	>=dev-libs/libgpg-error-1.4
	>=x11-libs/gtk+-2.10.0:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	default
	sed -i 's/Application;//' gpa.desktop
}

src_configure() {
	econf \
		--with-gpgme-prefix=/usr \
		--with-libassuan-prefix=/usr \
		$(use_enable nls) \
		GPGKEYS_LDAP="/usr/libexec/gpgkeys_ldap"
}
