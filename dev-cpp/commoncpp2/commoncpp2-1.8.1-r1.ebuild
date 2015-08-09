# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

DESCRIPTION="C++ framework offering portable support for threading, sockets, file access, daemons, persistence, serial I/O, XML parsing, and system services"
SRC_URI="mirror://gnu/commoncpp/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/commoncpp/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="debug doc examples ipv6 gnutls ssl static-libs"
REQUIRED_USE="gnutls? ( ssl )"

RDEPEND="ssl? ( gnutls? ( dev-libs/libgcrypt:0
			net-libs/gnutls )
		!gnutls? ( dev-libs/openssl ) )
	sys-libs/zlib"
DEPEND="doc? ( >=app-doc/doxygen-1.3.6 )
	${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}/1.8.1-configure_detect_netfilter.patch" \
		"${FILESDIR}/1.8.0-glibc212.patch" \
		"${FILESDIR}/1.8.1-autoconf-update.patch" \
		"${FILESDIR}/1.8.1-fix-buffer-overflow.patch" \
		"${FILESDIR}/1.8.1-parallel-build.patch"
	eautoreconf
}

src_configure() {
	use doc || \
		sed -i "s/^DOXYGEN=.*/DOXYGEN=no/" configure || die "sed failed"

	local myconf

	if use gnutls; then
		myconf="--with-gnutls"
	else
		use ssl && myconf="--with-openssl"
	fi

	econf \
		$(use_enable debug) \
		$(use_with ipv6) \
		$(use_enable static-libs static) \
		${myconf}
}

src_install () {
	default
	prune_libtool_files

	dodoc COPYING.addendum

	# Only install html docs
	# man and latex available, but seems a little wasteful
	use doc && dohtml doc/html/*

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		cd demo
		doins *.cpp *.h *.xml README
	fi
}

# Some of the tests hang forever
#src_test() {
#	cd "${S}/tests"
#	emake || die "emake tests failed"
#	./test.sh || die "tests failed"
#}
