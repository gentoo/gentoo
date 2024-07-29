# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

PATCHVER="003"

DESCRIPTION="Linux Driver support for the CoolKey and CAC products"
HOMEPAGE="https://directory.fedora.redhat.com/wiki/CoolKey"
SRC_URI="https://directory.fedora.redhat.com/download/coolkey/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCHVER}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

RDEPEND=">=sys-apps/pcsc-lite-1.6.4
	dev-libs/nss[utils]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=app-crypt/ccid-1.4.0"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}/${PN}-patches"
	"${FILESDIR}/${P}-clang16.patch"
)

pkg_setup() {
	pk="pk11install"
	dbdir="/etc/pki/nssdb"
	ck_mod_name="CoolKey PKCS #11 Module"

	if ! [[ -x $dbdir ]]; then
		ewarn "No /etc/pki/nssdb found; check under \$HOME/.pki and"
		ewarn "follow the suggested commands using the correct path."
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf \
		--enable-pk11install \
		$(use_enable debug)
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install -j1
	einstalldocs
}

pkg_postinst() {
	if [[ -x $dbdir ]]; then
		if ! $(modutil -rawlist -dbdir $dbdir | grep libcoolkeypk11); then
			elog "You still need to install libcoolkey in your PKCS11 library:"
			elog "$pk -p $dbdir 'name=$ck_mod_name library=libcoolkeypk11.so'"

		fi
	else
		elog ""
		elog "You still need to setup your PKCS11 library, or at least"
		elog "find where it is (perhaps \$HOME/.pki/nssdb).  Once you"
		elog "find it, use 'modutil -rawlist -dbdir \$db' to look for"
		elog "libcoolkeypk11.so, and if not found, add it using:"
		elog ""
		elog "$pk -p \$db 'name=$ck_mod_name library=libcoolkeypk11.so'"
		elog ""
		elog "where \$db is the full path to your pki/nssdb directory."
		elog ""
	fi
}

pkg_postrm() {
	if [[ -x $dbdir ]]; then
		if $(modutil -rawlist -dbdir $dbdir | grep libcoolkeypk11); then
			elog "You should remove libcoolkey from your PKCS11 library."
		fi
	fi
}
