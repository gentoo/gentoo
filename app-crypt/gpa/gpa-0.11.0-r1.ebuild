# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="GNU Privacy Assistant (GPA): a graphical user interface for GnuPG"
HOMEPAGE="https://gnupg.org/software/gpa/"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE="nls"

RDEPEND="
	>=app-crypt/gnupg-2:=
	>=app-crypt/gpgme-1.11.1:=
	>=dev-libs/libassuan-1.1.0:=
	>=dev-libs/libgpg-error-1.33:=
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	# Backports, drop on bump
	"${FILESDIR}"/${PV}
)

src_prepare() {
	default

	sed -i 's/Application;//' gpa.desktop || die
}

src_configure() {
	econf \
		$(use_enable nls) \
		GPGKEYS_LDAP="/usr/libexec/gpgkeys_ldap"
}
