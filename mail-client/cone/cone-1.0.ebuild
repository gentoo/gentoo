# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="CONE: COnsole News reader and Emailer"
HOMEPAGE="https://www.courier-mta.org/cone/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="crypt fam gnutls idn ipv6 ldap spell"

RDEPEND="
	dev-libs/libxml2
	sys-libs/ncurses:0=
	>=net-libs/courier-unicode-2
	spell? ( app-text/aspell )
	crypt? ( >=app-crypt/gnupg-1.0.4 )
	fam? ( virtual/fam )
	gnutls? (
		net-libs/gnutls:0=
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error
	)
	!gnutls? ( >=dev-libs/openssl-0.9.6:0= )
	idn? ( net-dns/libidn:0= )
	ipv6? ( net-dns/libidn:0= )
	ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
	dev-lang/perl"

PATCHES=( "${FILESDIR}"/${P}-no-spelling.patch )
DOCS=( AUTHORS ChangeLog INSTALL NEWS README )

src_prepare() {
	default

	# move local macro to m4 and run eautoreconf
	mkdir "${S}"/m4 || die
	sed -n -e '/# AC_PROG_SYSCONFTOOL/,+33 p' "${S}"/aclocal.m4 > m4/sysconftool.m4 || die
	sed -i -e '/^SUBDIRS/i ACLOCAL_AMFLAGS = -I m4' "${S}"/Makefile.am || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-notice=unicode
		--with-spellcheck=$(usex spell aspell none)
		$(use_with ldap ldapaddressbook)
		$(use_with gnutls)
		$(use_with idn libidn)
		$(use_with ipv6)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	emake DESTDIR="${D}" install-configure
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]]; then
		elog "See the \"Upgrading from version 0.96 and earlier\" section in"
		elog "${EROOT}/usr/share/doc/${PF}/INSTALL for information on updating"
		elog "older installs."
	fi
}
