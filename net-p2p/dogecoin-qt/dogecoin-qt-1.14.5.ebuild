# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop
DESCRIPTION="Dogecoin Core Qt 1.14.5 (with Graphical User Interface)"
HOMEPAGE="https://github.com/dogecoin"
SRC_URI="https://github.com/dogecoin/dogecoin/archive/refs/tags/v${PV}.tar.gz -> ${PN}-v${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
DB_VER="5.3"
KEYWORDS="~amd64 ~x86"
IUSE="tests +wallet zmq"
DOGEDIR="/opt/${PN}"
DEPEND="
	dev-libs/libevent:=
	dev-libs/protobuf
	dev-libs/openssl
	sys-devel/libtool
	sys-devel/automake:=
	>=dev-libs/boost-1.77.0-r4
	wallet? ( sys-libs/db:"${DB_VER}"=[cxx] )
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtwidgets
	dev-qt/qtdbus
	dev-qt/linguist-tools:=
	wallet? ( media-gfx/qrencode )
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
		$(use_with wallet incompatible-bdb)
		--bindir="${DOGEDIR}/bin"
		CPPFLAGS="-I/usr/include/db${DB_VER}"
		CFLAGS="-I/usr/include/db${DB_VER}"
		--with-gui=qt5
		--with-qt-incdir=/usr/include/qt5
		$(use_enable zmq)
		$(use_enable wallet)
		$(use_enable tests tests)
	)
	econf "${my_econf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	insinto "${DOGEDIR}"
	dosym "${DOGEDIR}/bin/dogecoin-qt" "/usr/bin/dogecoin-qt"
	doicon "${FILESDIR}/dogecoin.png"
	domenu "${FILESDIR}/dogecoin-qt.desktop"
}

pkg_postinst() {
	elog "Dogecoin Core Qt ${PV} has been installed."
	elog "Dogecoin Core Qt binaries have been placed in ${DOGEDIR}/bin."
	elog "dogecoin-qt has been symlinked with /usr/bin/dogecoin-qt."
}
