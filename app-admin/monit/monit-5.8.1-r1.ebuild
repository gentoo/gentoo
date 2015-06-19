# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/monit/monit-5.8.1-r1.ebuild,v 1.3 2015/02/11 23:22:22 blueness Exp $

EAPI="5"
inherit systemd

DESCRIPTION="a utility for monitoring and managing daemons or similar programs running on a Unix system"
HOMEPAGE="http://mmonit.com/monit/"
SRC_URI="http://mmonit.com/monit/dist/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="pam ssl"

RDEPEND="ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison
	pam? ( virtual/pam )"

src_prepare() {
	sed -i -e '/^INSTALL_PROG/s/-s//' Makefile.in || die "sed failed in Makefile.in"
}

src_configure() {
	econf $(use_with ssl) $(use_with pam) || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc README*
	dohtml -r doc/*

	insinto /etc; insopts -m600; doins monitrc || die "doins monitrc failed"
	newinitd "${FILESDIR}"/monit.initd-5.0-r1 monit || die "newinitd failed"
	systemd_dounit "${FILESDIR}"/${PN}.service || die
}

pkg_postinst() {
	elog "Sample configurations are available at:"
	elog "http://mmonit.com/monit/documentation/"
}
