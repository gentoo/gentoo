# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="The GNU Privacy Assistant (GPA) is a graphical user interface for GnuPG"
HOMEPAGE="https://gnupg.org/software/gpa/"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"
# Backport of upstream changes to 0.10.0
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-autoconf.patch.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE="nls"

RDEPEND="
	>=app-crypt/gnupg-2:=
	>=app-crypt/gpgme-1.11.1:=
	>=dev-libs/libassuan-1.1.0:=
	>=dev-libs/libgpg-error-1.4:=
	>=x11-libs/gtk+-2.10.0:2=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${WORKDIR}"/${P}-autoconf.patch
)

src_prepare() {
	default

	sed -i 's/Application;//' gpa.desktop || die

	# bug #934802 (can drop on next release > 0.10.0)
	rm m4/libassuan.m4 || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		GPGKEYS_LDAP="/usr/libexec/gpgkeys_ldap"
}
