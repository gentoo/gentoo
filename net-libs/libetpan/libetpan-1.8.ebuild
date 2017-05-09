# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="A portable, efficient middleware for different kinds of mail access"
HOMEPAGE="http://libetpan.sourceforge.net/"
SRC_URI="https://github.com/dinhviethoa/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="berkdb debug gnutls ipv6 liblockfile libressl sasl ssl static-libs"

DEPEND="sys-libs/zlib
	berkdb? ( sys-libs/db:= )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)
	sasl? ( dev-libs/cyrus-sasl:2 )
	liblockfile? ( net-libs/liblockfile )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-nonnull.patch
)

pkg_setup() {
	if use gnutls && ! use ssl ; then
		ewarn "You have \"gnutls\" USE flag enabled but \"ssl\" USE flag disabled!"
		ewarn "No ssl support will be available in ${PN}."
	fi
}

src_prepare() {
	default

	sed -i \
		-e "s/-O2 -g//" \
		configure.ac

	eautoreconf
}

src_configure() {
	# in Prefix emake uses SHELL=${BASH}, export CONFIG_SHELL to the same so
	# libtool recognises it as valid shell (bug #300211)
	use prefix && export CONFIG_SHELL=${BASH}
	# The configure script contains an error, in that it doesn't check the
	# argument of --enable-{debug,optim}, hence --disable-debug results in
	# --enable-debug=no, which isn't checked and debugging flags are blindly
	# injected.  So, avoid passing --disable-debug when we don't need it.
	local myeconfargs=(
		$(usex debug '--enable-debug' '')
		$(use_enable berkdb db)
		$(use_with sasl)
		$(use_enable ipv6)
		$(use_enable liblockfile lockfile)
		$(usex ssl "$(use_with gnutls) $(use_with !gnutls openssl)" '--without-gnutls --without-openssl')
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if ! use static-libs ; then
		find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
	fi
}
