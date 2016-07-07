# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="monitor"

DESCRIPTION="Monitoring application for www-servers/hiawatha"
HOMEPAGE="http://www.hiawatha-webserver.org/howto/monitor"
SRC_URI="http://www.hiawatha-webserver.org/files/${MY_P}-${PV}.tar.gz "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=dev-lang/php-5*[mysql,xslt]
	virtual/cron
	virtual/mysql
	www-servers/hiawatha[xslt]"

S=${WORKDIR}/${MY_P}

src_install () {
	default

	rm -f ChangeLog README LICENSE

	insinto /usr/share/${PN}
	doins -r *
}
