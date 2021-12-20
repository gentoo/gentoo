# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dogecoin Core 1.14.5 of blockchain node and RPC server."
HOMEPAGE="https://github.com/dogecoin"
SRC_URI="https://github.com/dogecoin/dogecoin/archive/refs/tags/v${PV}.tar.gz -> ${PN}-v${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
DB_VER="5.3"
KEYWORDS="~amd64 ~x86"
IUSE="tests +wallet zmq"
DOGEDIR="/opt/${PN}"
DEPEND="
	dev-libs/openssl
	sys-devel/libtool
	sys-devel/automake:=
	=dev-libs/boost-1.77.0-r4
	wallet? ( sys-libs/db:"${DB_VER}"=[cxx] )
	zmq? ( net-libs/cppzmq )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/autoconf
	sys-devel/automake
"
WORKDIR_="${WORKDIR}/dogecoin-${PV}"
S=${WORKDIR_}

src_configure() {
	chmod 755 ./autogen.sh
	./autogen.sh || die "autogen failed"
	local my_econf=(
		--enable-cxx
		--with-incompatible-bdb
		--bindir="${DOGEDIR}/bin"
		CPPFLAGS="-I/usr/include/db${DB_VER}"
		CFLAGS="-I/usr/include/db${DB_VER}"
		$(use_enable zmq)
		$(use_enable wallet)
		$(use_enable tests tests)
	)
	econf "${my_econf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	insinto "${DOGEDIR}"
	#Derived from net-p2p/bitcoind file operations.
	newins "${FILESDIR}/dogecoin.conf" "dogecoin.conf"
	fperms 600 "${DOGEDIR}/dogecoin.conf"
	dosym "${DOGEDIR}/bin/dogecoind" "/usr/bin/dogecoind"
}

pkg_postinst() {
	elog "Dogecoin Core ${PV} blockchain node and RPC server has been installed."
	elog "Dogecoin Core binaries have been placed in ${DOGEDIR}/bin."
	elog "dogecoind has been symlinked with /usr/bin/dogecoind."
	elog "dogecoin.conf is located under ${DOGEDIR}."
}
