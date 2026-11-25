# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dot-a linux-info

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/sahlberg/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sahlberg/${PN}/archive/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86"
	S="${WORKDIR}"/${PN}-${P}
fi

DESCRIPTION="Client library for accessing NFS shares over a network"
HOMEPAGE="https://github.com/sahlberg/libnfs"

LICENSE="LGPL-2.1 GPL-3"
SLOT="0/18" # sub-slot matches SONAME major
IUSE="gnutls kerberos static-libs utils"
# no test: The tests will ask for your password as it needs sudo access to
# run exportfs to create/remove the share we use for testing.

RDEPEND="
	gnutls? ( >=net-libs/gnutls-3.4.5:= )
	kerberos? ( virtual/krb5 )
"
DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
"

# net-libs/rpcsvc-proto for rpcgen called in build system
BDEPEND="
	net-libs/rpcsvc-proto
	virtual/pkgconfig
"

pkg_setup() {
	if use gnutls; then
		CONFIG_CHECK="~TLS"
		ERROR_TLS="RPC-with-TLS requires TLS in-kernel support."
		linux-info_pkg_setup
	fi
}

src_prepare() {
	use static-libs && lto-guarantee-fat
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_enable gnutls tls)
		$(use_with kerberos libkrb5)
		$(use_enable utils)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	use static-libs && strip-lto-bytecode

	rm examples/{CMakeLists.txt,Makefile*} || die
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples/

	find "${ED}" -name "*.la" -delete || die
}
