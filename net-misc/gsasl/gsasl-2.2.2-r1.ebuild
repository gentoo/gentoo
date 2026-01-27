# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gsasl.asc
inherit branding multilib-minimal verify-sig

DESCRIPTION="The GNU SASL client, server, and library"
HOMEPAGE="https://www.gnu.org/software/gsasl/"
SRC_URI="
	mirror://gnu/${PN}/${P}.tar.gz
	verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )
"

LICENSE="GPL-3"
SLOT="0"
# Before giving keywords (or ideally even bumping), please check https://www.gnu.org/software/gsasl/ to see
# if it's a stable release or not!
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="+client gcrypt gnutls idn kerberos nls ntlm +server static-libs"
REQUIRED_USE="|| ( client server )"

DEPEND="
	!net-libs/libgsasl
	sys-libs/readline:=
	gcrypt? ( dev-libs/libgcrypt:= )
	gnutls? ( net-libs/gnutls:= )
	idn? ( net-dns/libidn:= )
	kerberos? ( >=net-libs/libgssglue-0.5-r1 )
	nls? ( >=sys-devel/gettext-0.18.1 )
	ntlm? ( >=net-libs/libntlm-0.3.5 )
"
RDEPEND="${DEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gsasl )"

QA_CONFIG_IMPL_DECL_SKIP=(
	# gnulib FPs
	unreachable
	MIN
	alignof
	static_assert
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local krb5_impl="--with-gssapi-impl=no"

	# See https://blog.josefsson.org/2022/07/14/towards-pluggable-gss-api-modules/
	if use kerberos; then
		krb5_impl="--with-gssapi-impl=gssglue"
	fi

	local myeconfargs=(
		--disable-gcc-warnings
		--disable-valgrind-tests
		--disable-rpath

		# Even with multilib we need at least one of these enabled
		# so rely on REQUIRED_USE to enforce that and purge the non-native
		# bins in multilib_src_install
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

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default

	if ! multilib_is_native_abi ; then
		rm -f "${ED}"/usr/bin/gsasl* || die
	fi

	if ! use static-libs; then
		rm -f "${ED}"/usr/lib*/lib*.la || die
	fi
}

multilib_src_install_all() {
	doman doc/gsasl.1 doc/man/*.3
}

pkg_postinst() {
	ewarn "For USE=kerberos, ${PN} now uses libgssglue to allow choosing"
	ewarn "the Kerberos implementation at runtime."
	elog "See https://blog.josefsson.org/2022/07/14/towards-pluggable-gss-api-modules/"
	elog "for more details."
}
