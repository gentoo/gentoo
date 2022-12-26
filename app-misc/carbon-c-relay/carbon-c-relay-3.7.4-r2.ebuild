# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Enhanced C version of Carbon relay, aggregator and rewriter"
HOMEPAGE="https://github.com/grobian/carbon-c-relay"
SRC_URI="https://github.com/grobian/carbon-c-relay/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="lz4 snappy zlib ssl pcre2 +oniguruma"

# ensure only one of pcre2 and oniguruma is set, or none (libc)
REQUIRED_USE="
	pcre2?     ( !oniguruma )
	oniguruma? ( !pcre2 )
"
RDEPEND="lz4? ( app-arch/lz4 )
	snappy? ( app-arch/snappy )
	zlib? ( app-arch/gzip )
	ssl? ( dev-libs/openssl:0= )
	pcre2? ( dev-libs/libpcre2 )
	oniguruma? ( dev-libs/oniguruma )
	acct-group/carbon
	acct-user/carbon"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_with lz4) \
		$(use_with snappy) \
		$(use_with ssl) \
		$(use_with zlib gzip) \
		--without-pcre \
		$(use_with pcre2) \
		$(use_with oniguruma)
}

src_install() {
	default

	# rename too generic name
	mv "${ED}"/usr/bin/{relay,${PN}} || die

	# remove libfaketime, necessary for testing only
	rm -f "${ED}"/usr/$(get_libdir)/libfaketime.*

	dodoc ChangeLog.md

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
}
