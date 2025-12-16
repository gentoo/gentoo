# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="High-level C Binding for ZeroMQ"
HOMEPAGE="http://czmq.zeromq.org"
SRC_URI="https://github.com/zeromq/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/4"
KEYWORDS="amd64 arm arm64 ~hppa ~ppc64 ~riscv x86"
IUSE="curl drafts http-client http-server lz4 nss systemd test +uuid"
RESTRICT="!test? ( test )"

BDEPEND="app-text/asciidoc
	app-text/xmlto
	virtual/pkgconfig"

RDEPEND=">=net-libs/zeromq-4:=[drafts?]
	http-client? ( net-misc/curl )
	http-server? ( net-libs/libmicrohttpd:= )
	lz4? ( app-arch/lz4:= )
	nss? (
		dev-libs/nspr
		dev-libs/nss
	)
	systemd? ( sys-apps/systemd )
	uuid? ( sys-apps/util-linux:0 )"

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
		--with-nss=$(usex nss)
		$(use_enable test czmq_selftest)
	)

	# Force bash for configure until the fixes for bug #923922 land in a release
	# https://github.com/zeromq/zproject/pull/1336
	# https://github.com/zeromq/libzmq/pull/4651
	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
