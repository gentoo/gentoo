# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="High-level C Binding for ZeroMQ"
HOMEPAGE="http://czmq.zeromq.org"
SRC_URI="https://github.com/zeromq/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~x86"
IUSE="curl drafts http-client http-server lz4 static-libs systemd +uuid"

BDEPEND="app-text/asciidoc
	app-text/xmlto
	virtual/pkgconfig"

RDEPEND=">=net-libs/zeromq-4:=[drafts?]
	http-client? ( net-misc/curl )
	http-server? ( net-libs/libmicrohttpd:= )
	lz4? ( app-arch/lz4:= )
	systemd? ( sys-apps/systemd )
	uuid? ( sys-apps/util-linux:0= )"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README.md )

src_configure() {
	local myeconfargs=(
		--enable-drafts=$(usex drafts)
		--with-docs=no
		--with-uuid=$(usex uuid)
		--with-libcurl=$(usex http-client)
		--with-libmicrohttpd=$(usex http-server)
		--with-libsystemd=$(usex systemd)
		--with-liblz4=$(usex lz4)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use static-libs ; then
		find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
	fi
}
