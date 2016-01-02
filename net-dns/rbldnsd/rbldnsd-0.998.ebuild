# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils toolchain-funcs user python-single-r1

DESCRIPTION="DNS server designed to serve blacklist zones"
HOMEPAGE="http://www.corpit.ru/mjt/rbldnsd.html"
SRC_URI="http://www.corpit.ru/mjt/rbldnsd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86 ~x86-fbsd"
IUSE="ipv6 test zlib"

REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS}
		dev-python/pydns:2[${PYTHON_USEDEP}] )"

src_prepare() {
	epatch "${FILESDIR}/rbldnsd-0.997a-robust-ipv6-test-support.patch"
	epatch "${FILESDIR}/rbldnsd-0.997a-format-security-compile-fix.patch"
}

src_configure() {
	# The ./configure file is handwritten and doesn't support a `make
	# install` target, so there are no --prefix options. The econf
	# function appends those automatically, so we can't use it.
	./configure \
		$(use_enable ipv6) \
		$(use_enable zlib) \
		|| die "./configure failed"
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)"
}

src_test() {
	emake check \
		CC="$(tc-getCC)" \
		PYTHON="${PYTHON}"
}

src_install() {
	dosbin rbldnsd
	doman rbldnsd.8
	keepdir /var/db/rbldnsd
	dodoc CHANGES* TODO NEWS README*
	newinitd "${FILESDIR}"/initd-0.997a rbldnsd
	newconfd "${FILESDIR}"/confd-0.997a rbldnsd
}

pkg_postinst() {
	enewgroup rbldns
	enewuser rbldns -1 -1 /var/db/rbldnsd rbldns
	chown rbldns:rbldns /var/db/rbldnsd
}
