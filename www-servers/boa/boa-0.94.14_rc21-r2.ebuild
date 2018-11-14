# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils systemd

MY_P=${P/_/}
DESCRIPTION="A very small and very fast http daemon"
SRC_URI="http://www.boa.org/${MY_P}.tar.gz"
HOMEPAGE="http://www.boa.org/"

KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND=""
DEPEND="sys-devel/bison
	sys-devel/flex
	doc? ( virtual/latex-base )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-texi.patch
	epatch "${FILESDIR}"/${P}-ENOSYS.patch
}

src_compile() {
	default

	use doc || sed -i -e '/^all:/s/boa.dvi //' docs/Makefile
	emake docs
}

src_install() {
	dosbin src/boa
	doman docs/boa.8
	doinfo docs/boa.info
	if use doc; then
		dodoc docs/boa.html
		dodoc docs/boa_banner.png
		dodoc docs/boa.dvi
	fi

	keepdir /var/log/boa
	keepdir /var/www/localhost/htdocs
	keepdir /var/www/localhost/cgi-bin
	keepdir /var/www/localhost/icons

	newinitd "${FILESDIR}"/boa.initd boa
	newconfd "${FILESDIR}"/boa.conf.d boa

	systemd_dounit "${FILESDIR}"/boa.service

	exeinto /usr/lib/boa
	doexe src/boa_indexer

	insinto /etc/boa
	doins "${FILESDIR}"/boa.conf
	doins "${FILESDIR}"/mime.types
}
