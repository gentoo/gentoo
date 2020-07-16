# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A portable, efficient middleware for different kinds of mail access"
HOMEPAGE="http://libetpan.sourceforge.net/"
SRC_URI="https://github.com/dinhviethoa/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="berkdb gnutls ipv6 liblockfile libressl lmdb sasl ssl static-libs"

# BerkDB is only supported up to version 6.0
DEPEND="sys-libs/zlib
	!lmdb? ( berkdb? ( sys-libs/db:= ) )
	lmdb? ( dev-db/lmdb )
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
	"${FILESDIR}"/${PN}-1.9.4-berkdb_lookup.patch #519846
	"${FILESDIR}"/${PN}-1.9.4-pkgconfig_file_no_ldflags.patch
)

pkg_pretend() {
	if use gnutls && ! use ssl ; then
		ewarn "You have \"gnutls\" USE flag enabled but \"ssl\" USE flag disabled!"
		ewarn "No ssl support will be available in ${PN}."
	fi

	if use berkdb && use lmdb ; then
		ewarn "You have \"berkdb\" _and_ \"lmdb\" USE flags enabled."
		ewarn "Using lmdb as cache DB!"
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# in Prefix emake uses SHELL=${BASH}, export CONFIG_SHELL to the same so
	# libtool recognises it as valid shell (bug #300211)
	use prefix && export CONFIG_SHELL=${BASH}
	local myeconfargs=(
		# --enable-debug simply injects "-O2 -g" into CFLAGS
		--disable-debug
		$(use_enable ipv6)
		$(use_enable liblockfile lockfile)
		$(use_enable static-libs static)
		$(use_with sasl)
		$(usex lmdb '--enable-lmdb --disable-db' "$(use_enable berkdb db) --disable-lmdb")
		$(usex ssl "$(use_with gnutls) $(use_with !gnutls openssl)" '--without-gnutls --without-openssl')
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
