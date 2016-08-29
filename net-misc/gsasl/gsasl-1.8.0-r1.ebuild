# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils

DESCRIPTION="The GNU SASL client, server, and library"
HOMEPAGE="https://www.gnu.org/software/gsasl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc gcrypt idn kerberos nls ntlm static-libs +threads"

DEPEND="
	gcrypt? ( dev-libs/libgcrypt:0 )
	idn? ( net-dns/libidn )
	kerberos? ( virtual/krb5 )
	nls? ( >=sys-devel/gettext-0.18.1 )
	ntlm? ( net-libs/libntlm )
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-gss-extra.patch"
	sed -i -e '/gl_WARN_ADD(\[-Werror/d' \
		-e 's/ -Werror//' configure.ac || die
	sed -i -e 's/ -Werror//' lib/configure.ac || die
	eautoreconf
}

src_configure() {
	local krb5_impl
	if use kerberos; then
		krb5_impl="--with-gssapi-impl="
		krb5_impl+=$(has_version app-crypt/mit-krb5 && echo "mit" || echo "heimdal")
	fi
	econf \
		--enable-client \
		--enable-server \
		--disable-valgrind-tests \
		--disable-rpath \
		--without-libshishi \
		--without-libgss \
		--disable-kerberos_v5 \
		$(use_enable kerberos gssapi) \
		${krb5_impl} \
		$(use_enable kerberos gs2) \
		$(use_with gcrypt libgcrypt) \
		$(use_enable nls) \
		$(use_with idn stringprep) \
		$(use_enable ntlm) \
		$(use_with ntlm libntlm) \
		$(use_enable static-libs static) \
		$(use_enable threads)
}

src_install() {
	default
	if ! use static-libs; then
		rm -f "${D}"/usr/lib*/lib*.la
	fi
	doman doc/gsasl.1 doc/man/*.3

	if use doc; then
		dodoc doc/*.{eps,ps,pdf}
		dohtml doc/*.html
		docinto examples
		dodoc examples/*.c
	fi
}
