# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dogecoin (unstable) 1.14.5 Development version with new code for future release."
HOMEPAGE="https://github.com/dogecoin"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/heads/${PV}-dev.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
DB_VER="5.3"
KEYWORDS="~amd64 ~x86"
IUSE="gui +src test +wallet zmq"
REQUIRED_USE="^^ ( wallet )"
RESTRICT="!test? ( test )"
BINDIR="/opt/${PN}"
DEPEND="
	dev-libs/libevent:=
	dev-libs/protobuf
	dev-libs/openssl
	sys-devel/libtool
	sys-devel/automake:=
	=dev-libs/boost-1.76.0-r1
	wallet? ( sys-libs/db:"${DB_VER}"=[cxx] )
	gui? ( dev-qt/qtcore dev-qt/qtgui dev-qt/qtwidgets dev-qt/qtdbus dev-qt/linguist-tools:= media-gfx/qrencode )
	zmq? ( net-libs/cppzmq )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/autoconf
	sys-devel/automake
"
WORKDIR_="${WORKDIR}/dogecoin-${PV}-dev"
S=${WORKDIR_}

src_configure() {
	chmod 755 ./autogen.sh
	./autogen.sh || die "autogen failed"
	local my_econf=(
		--enable-cxx
		--with-incompatible-bdb
		CPPFLAGS="-I/usr/include/db${DB_VER}" CFLAGS="-I/usr/include/db${DB_VER}"
		--with-gui=$(usex gui qt5 no)
		$(use_enable test tests)
		$(use_with gui qt-incdir /usr/include/qt5)
		$(use_enable zmq)
	)
	econf "${my_econf[@]}"
}

src_install() {
	mkdir -p "${ED}/${BINDIR}"
	emake DESTDIR="${ED}/${BINDIR}" install
}

pkg_postinst() {
	elog "${P} (unstable) development release has been installed."
	elog "Doge binaries have been placed in ${BINDIR}/usr/bin."
	if use src; then
		mkdir -p "${BINDIR}/src"
		mv "${WORKDIR_}" "${BINDIR}/src"
		elog "Doge source files have been placed in ${BINDIR}/src."
	fi
}
