# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user

DESCRIPTION="Open source DMARC implementation "
HOMEPAGE="http://www.trusteddomain.org/opendmarc/"
SRC_URI="mirror://sourceforge/opendmarc/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~x86 ~x86-fbsd"
IUSE="spf"

DEPEND="dev-perl/DBI
	|| ( mail-filter/libmilter mail-mta/sendmail )"
RDEPEND="${DEPEND}
	dev-perl/Switch
	spf? ( mail-filter/libspf2 )"

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 /var/lib/milter milter
}

src_configure() {
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		$(use_with spf)
}

src_install() {
	default

	newinitd "${FILESDIR}"/opendmarc.initd opendmarc
	newconfd "${FILESDIR}"/opendmarc.confd opendmarc

	dodir /etc/opendmarc
	dodir /var/run/opendmarc
	fowners milter:milter /var/run/opendmarc

	# create config file
	sed \
		-e 's/^# UserID .*$/UserID milter/' \
		-e 's/^# PidFile .*/PidFile \/var\/run\/opendmarc\/opendmarc.pid/' \
		-e '/^# Socket /s/^# //' \
		"${S}"/opendmarc/opendmarc.conf.sample \
		> "${ED}"/etc/opendmarc/opendmarc.conf \
		|| die
}
