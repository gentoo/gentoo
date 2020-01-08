# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Enhanced C version of Carbon relay, aggregator and rewriter"
HOMEPAGE="https://github.com/grobian/carbon-c-relay"
SRC_URI="https://github.com/grobian/carbon-c-relay/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="lz4 snappy zlib ssl pcre pcre2 +oniguruma"

# ensure only one of pcre, pcre2 and oniguruma is set, or none (libc)
# unforunately pcre is in global USE, so we have to exclude that here
REQUIRED_USE="
	pcre2?     ( !oniguruma )
	oniguruma? ( !pcre2 )
"
RDEPEND="lz4? ( app-arch/lz4 )
	snappy? ( app-arch/snappy )
	zlib? ( app-arch/gzip )
	ssl? ( dev-libs/openssl:0 )
	!oniguruma? ( !pcre2? ( pcre? ( dev-libs/libpcre ) ) )
	pcre2? ( dev-libs/libpcre2 )
	oniguruma? ( dev-libs/oniguruma )"
DEPEND="${RDEPEND}"

pkg_preinst() {
	enewgroup carbon
	enewuser carbon -1 -1 -1 carbon
}

src_configure() {
	local pcrecfg
	if use !pcre2 && use !oniguruma ; then
		pcrecfg=$(use_with pcre)
	else
		pcrecfg="--without-pcre"
	fi

	econf $(use_with lz4) $(use_with snappy) \
		$(use_with ssl) $(use_with zlib gzip) \
		"${pcrecfg}" $(use_with pcre2) $(use_with oniguruma)
}

src_install() {
	default

	# rename too generic name
	mv "${ED}"/usr/bin/{relay,${PN}} || die

	# remove libfaketime, necessary for testing only
	rm -f "${ED}"/usr/$(get_libdir)/libfaketime.*

	dodoc ChangeLog.md

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
}
