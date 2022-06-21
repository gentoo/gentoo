# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="The GNU SASL client, server, and library"
HOMEPAGE="https://www.gnu.org/software/gsasl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
# Before giving keywords (or ideally even bumping), please check https://www.gnu.org/software/gsasl/ to see
# if it's a stable release or not!
KEYWORDS="~amd64 ~ppc ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+client doc gcrypt gnutls idn kerberos nls ntlm +server static-libs"
REQUIRED_USE="|| ( client server )"

DEPEND="
	!net-libs/libgsasl
	gcrypt? ( dev-libs/libgcrypt:0= )
	gnutls? ( net-libs/gnutls:= )
	idn? ( net-dns/libidn:= )
	kerberos? ( virtual/krb5 )
	nls? ( >=sys-devel/gettext-0.18.1 )
	ntlm? ( >=net-libs/libntlm-0.3.5 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i \
		-e '/gl_WARN_ADD(\[-Werror/d' \
		-e 's/ -Werror//' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	local krb5_impl

	if use kerberos; then
		krb5_impl="--with-gssapi-impl="

		# These are the two providers of virtual/krb5
		if has_version app-crypt/mit-krb5; then
			krb5_impl+="mit"
		else
			krb5_impl+="heimdal"
		fi
	fi

	local myeconfargs=(
		--disable-valgrind-tests
		--disable-rpath

		--with-packager-bug-reports="https://bugs.gentoo.org"
		--with-packager-version="r${PR}"
		--with-packager="Gentoo Linux"

		$(use_enable client)
		$(use_enable server)

		$(use_enable kerberos gssapi)
		${krb5_impl}
		$(use_enable kerberos gs2)

		$(use_with gcrypt libgcrypt)
		$(use_with gnutls)
		$(use_enable nls)
		$(use_with idn stringprep)
		$(use_enable ntlm)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use static-libs; then
		rm -f "${ED}"/usr/lib*/lib*.la || die
	fi

	doman doc/gsasl.1 doc/man/*.3

	if use doc; then
		dodoc doc/*.{eps,ps,pdf}
		docinto html
		dodoc doc/*.html
		docinto examples
		dodoc examples/*.c
	fi
}
