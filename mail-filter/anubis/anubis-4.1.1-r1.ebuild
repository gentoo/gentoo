# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils autotools pam toolchain-funcs user

DESCRIPTION="GNU Anubis is an outgoing mail processor"
HOMEPAGE="https://www.gnu.org/software/anubis/"

SRC_URI="mirror://gnu/anubis/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="crypt guile mysql postgres nls pam pcre sasl socks5 +gnutls tcpd test"

RDEPEND="sys-libs/gdbm
	crypt? ( >=app-crypt/gpgme-0.9.0 )
	guile? ( >=dev-scheme/guile-1.8 )
	mysql? ( virtual/mysql )
	pam?   ( virtual/pam )
	postgres? ( dev-db/postgresql[server] )
	nls? ( sys-devel/gettext )
	pcre? ( >=dev-libs/libpcre-3.9 )
	sasl? ( virtual/gsasl )
	gnutls?   ( net-libs/gnutls )
	tcpd?  ( >=sys-apps/tcp-wrappers-7.6 )"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

REQUIRED_USE="mysql? ( sasl )
	postgres? ( sasl )"

pkg_setup() {
	enewuser anubis
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gnutls.patch
	epatch "${FILESDIR}"/${PV}-gpgme.patch
	epatch "${FILESDIR}"/${PV}-testsuite.patch
	epatch "${FILESDIR}"/${PV}-gnutls3.patch
	sed -i -e "s/1024-bit ELG-E/1024-bit ELG/" \
		testsuite/etc/{gpgcrypt.pat,gpgse.pat}
	eautoreconf
}

src_configure() {
	local myconf
	if use crypt ; then
		myconf="--with-gpgme --with-gpgme-prefix=$(gpgme-config --prefix)"
	else
		myconf="--without-gpgme"
	fi
	econf --with-unprivileged-user=anubis \
		--disable-rpath \
		$(use_with mysql) \
		$(use_with postgres) \
		$(use_with pam) \
		$(use_with pcre) \
		$(use_enable nls) \
		$(use_with guile) \
		$(use_with sasl gsasl) \
		$(use_with gnutls) \
		$(use_with tcpd tcp-wrappers) \
		$(use_with socks5 socks-proxy) \
		${myconf}
}

src_compile() {
	# parallel make fails
	emake AR=$(tc-getAR) -j1
}

src_test() {
	cd "${S}/testsuite"
	emake -j1 check
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog INSTALL NEWS README* THANKS TODO
	docinto examples
	dodoc examples/*anubis*
	docinto guile
	dodoc guile/*.scm

	if use pam ; then
		pamd_mimic system-auth anubis auth account session
	fi

	rm -rf "${D}"/usr/share/anubis
}
