# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Modular, multithreaded web application server extensible with C++"
HOMEPAGE="http://www.tntnet.org/"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="doc gnutls libressl server ssl"

RDEPEND=">=dev-libs/cxxtools-3.0
	sys-libs/zlib[minizip]
	ssl? (
		gnutls? (
			>=net-libs/gnutls-1.2.0
			dev-libs/libgcrypt:0
		)
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	app-arch/zip"

PATCHES=(
	"${FILESDIR}/${PN}-3.0-autoconf-2.70.patch"
)

src_prepare() {
	default

	eautoreconf

	sed -i -e 's:@localstatedir@:/var:' etc/tntnet/tntnet.xml.in || die

	# bug 423697
	sed -e "s:unzip.h:minizip/unzip.h:" -i framework/defcomp/unzipcomp.cpp || die

	# upstream still use bundeld zlib here
	sed -e "s:unzip.h:minizip/unzip.h:" -i framework/common/unzipfile.cpp || die
}

src_configure() {
	local myconf=""

	if ! use server; then
		myconf="${myconf} --disable-server"
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog README

	doman doc/man/{ecpp.7,ecppc.1,tntnet.8,tntnet.xml.7}

	if use server; then
		rm -f "${D}/etc/init.d/tntnet"
		newinitd "${FILESDIR}/tntnet-3.initd" tntnet
	fi

	# remove static libs
	rm -f "${ED}"/usr/$(get_libdir)/libtntnet{,_sdk}.la || die
}
