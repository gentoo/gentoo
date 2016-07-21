# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools base systemd

DESCRIPTION="GNU system accounting utilities"
HOMEPAGE="https://savannah.gnu.org/projects/acct/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-cross-compile.patch
	"${FILESDIR}"/${P}-no-gets.patch
	"${FILESDIR}"/${P}-texi-failure.patch
	"${FILESDIR}"/${P}-math.patch
)

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf --enable-linux-multiformat
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
	keepdir /var/account
	newinitd "${FILESDIR}"/acct.initd acct
	newconfd "${FILESDIR}"/acct.confd acct
	systemd_dounit "${FILESDIR}"/acct.service
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/acct.logrotate acct

	# sys-apps/sysvinit already provides this
	rm "${ED}"/usr/bin/last "${ED}"/usr/share/man/man1/last.1 || die

	# accton in / is only a temp workaround for #239748
	dodir /sbin
	mv "${ED}"/usr/sbin/accton "${ED}"/sbin/ || die
}
