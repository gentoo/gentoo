# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic multilib

DESCRIPTION="A free implementation of the Kerberos 5 network security system"
HOMEPAGE="https://www.gnu.org/software/shishi/"
SRC_URI="mirror://gnu/shishi/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnutls idn ipv6 nls pam +des +3des +aes +md +null +arcfour static-libs"

DEPEND="gnutls? ( net-libs/gnutls )
		idn? ( net-dns/libidn )
		dev-libs/libtasn1
		dev-libs/libgcrypt:0
		dev-libs/libgpg-error
		virtual/libiconv
		virtual/libintl"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix finding libresolv.so
	epatch "${FILESDIR}/${PN}_resolv.patch"
	# fix building with automake-1.12 bug #424095
	epatch "${FILESDIR}/${PN}_automake-1.12.patch"
	# fix building with glibc-2.16.0
	epatch "${FILESDIR}/${PN}_gets.patch"

	# don't create a new database
	sed -i -e '/install-data-hook/s/^/#/' Makefile.am || die

	eautoreconf
}

src_configure() {
	append-cppflags -DMAX_ERROR_DESCRIPTION_SIZE=ASN1_MAX_ERROR_DESCRIPTION_SIZE
	econf \
		$(use_enable pam) \
		$(use_enable nls) \
		$(use_enable ipv6) \
		$(use_with idn libidn-prefix) \
		$(use_enable gnutls starttls) \
		$(use_enable des) \
		$(use_enable 3des) \
		$(use_enable aes) \
		$(use_enable md) \
		$(use_enable null) \
		$(use_enable arcfour) \
		$(use_enable static-libs static) \
		--with-system-asn1 \
		--with-libgcrypt \
		--with-html-dir=/usr/share/doc/${P} \
		--with-db-dir=/var/shishi \
		--with-pam-dir=/$(get_libdir)/security \
		--disable-rpath \
		--with-packager="Gentoo" \
		--with-packager-bug-reports="https://bugs.gentoo.org/"
}

src_install() {
	emake DESTDIR="${D}" install

	keepdir /var/shishi
	fperms 0700 /var/shishi
	echo "db file /var/shishi" >> "${D}/etc/shishi/shisa.conf" || die

	newinitd "${FILESDIR}/shishid.init" shishid
	newconfd "${FILESDIR}/shishid.confd" shishid

	dodoc AUTHORS ChangeLog INSTALL NEWS README THANKS
	doman doc/man/* doc/*.1
	dohtml doc/reference/html/*
	doinfo doc/*.info*

	rm -f "${D}/$(get_libdir)/security/pam_shishi.la"
	use static-libs || find "${D}"/usr/lib* -name '*.la' -delete
}
