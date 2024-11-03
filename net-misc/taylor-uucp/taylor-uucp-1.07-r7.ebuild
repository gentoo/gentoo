# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Taylor UUCP"
HOMEPAGE="https://www.airs.com/ian/uucp.html"
SRC_URI="mirror://gnu/uucp/uucp-${PV}.tar.gz"
S="${WORKDIR}/uucp-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ~sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-fprintf.patch
	"${FILESDIR}"/${P}-remove-extern.patch
	"${FILESDIR}"/${P}-modernc.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die
	eautoreconf
}

src_configure() {
	append-cppflags -D_GNU_SOURCE -fno-strict-aliasing
	econf --with-newconfigdir=/etc/uucp
}

src_install() {
	dodir /usr/share/man/man{1,8}
	dodir /usr/share/info
	dodir /usr/bin /usr/sbin
	diropts -o uucp -g uucp -m 0750
	keepdir /var/log/uucp /var/spool/uucp
	diropts -o uucp -g uucp -m 0775
	keepdir /var/spool/uucppublic

	emake \
		"prefix=${ED}/usr" \
		"sbindir=${ED}/usr/sbin" \
		"bindir=${ED}/usr/bin" \
		"man1dir=${ED}/usr/share/man/man1" \
		"man8dir=${ED}/usr/share/man/man8" \
		"newconfigdir=${ED}/etc/uucp" \
		"infodir=${ED}/usr/share/info" \
		install install-info

	sed -i -e 's:/usr/spool:/var/spool:g' sample/config

	insinto etc/uucp
	doins sample/*

	dodoc ChangeLog NEWS README TODO
}
