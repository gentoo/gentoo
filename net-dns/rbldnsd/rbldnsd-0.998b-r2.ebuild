# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="DNS server designed to serve blacklist zones"
HOMEPAGE="https://rbldnsd.io/"
SRC_URI="https://github.com/spamhaus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~sparc x86"
IUSE="ipv6 zlib"

RDEPEND="zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"
BDEPEND="
	acct-group/rbldns
	acct-user/rbldns
"

# The test suite was dropped from the ebuild because it requires
# python-2.7, and it will crash if you try to run it now.
RESTRICT=test

src_configure() {
	# The ./configure file is handwritten and doesn't support a `make
	# install` target, so there are no --prefix options. The econf
	# function appends those automatically, so we can't use it. We
	# Have to set $CC here, too (and not just in the call to emake),
	# because the ./configure script checks for it.
	CC="$(tc-getCC)" ./configure \
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

src_install() {
	einstalldocs
	dosbin rbldnsd
	doman rbldnsd.8
	newinitd "${FILESDIR}"/initd-0.997a rbldnsd
	newconfd "${FILESDIR}"/confd-0.997a rbldnsd
	diropts -g rbldns -o rbldns -m 0750
	keepdir /var/db/rbldnsd
}
