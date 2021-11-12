# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dogecoin Core 1.18 development version of blockchain node and RPC server."
HOMEPAGE="https://github.com/dogecoin"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/heads/${PV}-dev.tar.gz -> ${P}-dev.tar.gz"
LICENSE="MIT"
SLOT="0"
DB_VER="5.3"
KEYWORDS="~amd64 ~x86"
IUSE="gui +src test +wallet zmq"
RESTRICT="!test? ( test )"
DOGEDIR="/opt/${PN}"
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
REQUIRED_USE="!wallet? ( || ( !gui ) )"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/autoconf
	sys-devel/automake
"
WORKDIR_="${WORKDIR}/${P}-dev"
S=${WORKDIR_}

src_configure() {
	chmod 755 ./autogen.sh
	./autogen.sh || die "autogen failed"
	local my_econf=(
		--enable-cxx
		--with-incompatible-bdb
		--bindir="${DOGEDIR}/bin"
		--datadir="${DOGEDIR}/dogecoind"
		CPPFLAGS="-I/usr/include/db${DB_VER}"
		CFLAGS="-I/usr/include/db${DB_VER}"
		--with-gui=$(usex gui qt5 no)
		$(use_enable test tests)
		$(use_with gui qt-incdir /usr/include/qt5)
		$(use_enable zmq)
		$(use_enable wallet)
	)
	econf "${my_econf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	insinto "${DOGEDIR}/dogecoind"
	#Derived from net-p2p/bitcoind file operations.
	newins "${FILESDIR}/dogecoin.conf" "dogecoin.conf"
	newins "${FILESDIR}/dogecoin.example.conf" "dogecoin.example.conf"
	fperms 600 "${DOGEDIR}/dogecoind/dogecoin.conf"
	fperms 600 "${DOGEDIR}/dogecoind/dogecoin.example.conf"
	if use src; then
		insinto "${DOGEDIR}/src"
		doins -r "${WORKDIR_}"
		elog "Dogecoin Core source files have been placed in ${DOGEDIR}/src."
	fi
}

pkg_postinst() {
	elog "${P} development version has been installed."
	elog "Dogecoin Core binaries have been placed in ${DOGEDIR}/bin."
	elog "dogecoin.conf is in ${DOGEDIR}/dogecoind/dogecoin.conf.  It can be symlinked with where the .dogecoin resides, for example: 'ln -s ${DOGEDIR}/dogecoind/dogecoin.conf /root/.dogecoin/dogecoin.conf'."
	if use src; then
		#Modify tests_config.py file SRCDIR and BUILDDIR variables with correct values where Dogecoin Core is installed
		sed -i "s#SRCDIR=\"${WORKDIR_}\"#SRCDIR=\"${DOGEDIR}/src/${P}-dev\"#g" "${DOGEDIR}/src/${P}-dev/qa/pull-tester/tests_config.py"
		sed -i "s#BUILDDIR=\"${WORKDIR_}\"#BUILDDIR=\"${DOGEDIR}/bin\"#g" "${DOGEDIR}/src/${P}-dev/qa/pull-tester/tests_config.py"
	fi
}
