# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Network capture utility designed specifically for DNS traffic"
HOMEPAGE="https://dnscap.dns-oarc.net/"
SRC_URI="https://www.dns-oarc.net/files/dnscap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cryptopant seccomp"

RDEPEND="
	app-arch/bzip2:=
	app-arch/lz4:=
	app-arch/xz-utils
	app-arch/zstd:=
	dev-libs/openssl:0=
	dev-perl/YAML
	net-libs/ldns:=
	net-libs/libpcap
	virtual/zlib:=
	cryptopant? ( app-crypt/cryptopant:= )
	seccomp? ( sys-libs/libseccomp )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# avoid automagic and building a fake plugin, cryptopant/cryptopant.c:161:
	# "no cryptopANT support built in, can't encrypt IP addresses"
	if ! use cryptopant; then
		sed -e 's:cryptopant::' -i plugins/Makefile.am  || die
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable seccomp)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	emake test
}

src_install() {
	default
	rm "${ED}"/usr/share/doc/${PF}/LICENSE || die
	find "${D}" -name '*.la' -delete || die
}
