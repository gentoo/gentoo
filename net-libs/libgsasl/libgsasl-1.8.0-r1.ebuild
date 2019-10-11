# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="The GNU SASL library"
HOMEPAGE="https://www.gnu.org/software/gsasl/"
SRC_URI="mirror://gnu/${PN/lib}/${P}.tar.gz"
LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="idn gcrypt kerberos nls ntlm static-libs"
DEPEND="
	gcrypt? ( dev-libs/libgcrypt:0 )
	idn? ( net-dns/libidn )
	kerberos? ( virtual/krb5 )
	nls? ( >=sys-devel/gettext-0.18.1 )
	ntlm? ( net-libs/libntlm )
"
RDEPEND="${DEPEND}
	!net-misc/gsasl"

PATCHES=(
	"${FILESDIR}/${PN}-gss-extra.patch"
)

src_prepare() {
	default
	sed -i -e 's/ -Werror//' configure.ac || die
	eautoreconf
}

src_configure() {
	local krb5_impl
	if use kerberos; then
		krb5_impl="--with-gssapi-impl="
		krb5_impl+=$(has_version app-crypt/mit-krb5 && echo "mit" || echo "heimdal")
	fi
	local myeconfargs=(
		$(use_with gcrypt libgcrypt)
		$(use_with idn stringprep)
		$(use_enable kerberos gssapi)
		${krb5_impl}
		$(use_enable nls)
		$(use_enable ntlm)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use static-libs; then
		rm -f "${D}"/usr/lib*/lib*.la
	fi
}
