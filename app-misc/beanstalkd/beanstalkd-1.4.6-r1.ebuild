# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/beanstalkd/beanstalkd-1.4.6-r1.ebuild,v 1.4 2012/06/01 00:26:21 zmedico Exp $

EAPI="3"

inherit eutils user

DESCRIPTION="A fast, distributed, in-memory workqueue service"
HOMEPAGE="http://xph.us/software/beanstalkd/"
SRC_URI="http://xph.us/dist/beanstalkd/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~mips x86 ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x64-macos ~x86-macos"

RDEPEND="dev-libs/libevent"
DEPEND="${RDEPEND}
	test? ( dev-lang/python )"

IUSE="debug test"

pkg_setup() {
	enewuser beanstalk -1 -1 /var/lib/beanstalkd daemon
}

src_prepare() {
	epatch "$FILESDIR/beanstalkd-werror-v2.patch"
	epatch "$FILESDIR/beanstalkd-dbgprintf.patch"
}

src_configure() {
	econf \
		--docdir="${EPREFIX}"/usr/share/${PF} \
		--with-event="${EPREFIX}"/usr \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	DATADIR=/var/lib/${PN}
	dodir ${DATADIR} || die "Install failed"
	fowners beanstalk:daemon ${DATADIR}

	dodoc README TODO doc/*.txt

	newconfd "${FILESDIR}/conf-1.4.2" beanstalkd
	newinitd "${FILESDIR}/init-${PV}" beanstalkd
}
