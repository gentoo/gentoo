# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTES:
# 1- use flag 'pgm' (OpenPGM support) must be masked by profiles for ARM archs;

EAPI=4

inherit autotools

DESCRIPTION="ZeroMQ is a brokerless messaging kernel with extremely high performance"
HOMEPAGE="http://www.zeromq.org"
SRC_URI="http://download.zeromq.org/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="pgm test static-libs"
RESTRICT="!test? ( test )"

RDEPEND="!net-libs/cppzmq"
DEPEND="pgm? (
		virtual/pkgconfig
		~net-libs/openpgm-5.1.118
	)
	|| ( sys-apps/util-linux sys-freebsd/freebsd-lib )"

src_prepare() {
	einfo "Removing bundled OpenPGM library"
	rm -r "${S}"/foreign/openpgm/libpgm* || die
	eautoreconf
}

src_configure() {
	local myconf
	use pgm && myconf="--with-system-pgm" || myconf="--without-pgm"
	econf \
		$(use_enable static-libs static) \
		$myconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS README AUTHORS ChangeLog
	doman doc/*.[1-9]

	# remove useless .la files
	find "${D}" -name '*.la' -delete

	# remove useless .a (only for non static compilation)
	use static-libs || find "${D}" -name '*.a' -delete
}
