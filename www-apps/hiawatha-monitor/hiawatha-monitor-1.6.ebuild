# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="monitor"

DESCRIPTION="Monitoring application for www-servers/hiawatha"
HOMEPAGE="https://www.hiawatha-webserver.org/howto/monitor"
SRC_URI="https://www.hiawatha-webserver.org/files/${MY_P}-${PV}.tar.gz "

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/php-5:*[mysql,mysqli,xslt]
	virtual/cron
	virtual/mysql
	www-servers/hiawatha[xslt]"

S=${WORKDIR}/${MY_P}

DOCS=( ChangeLog README.md INSTALL )

src_install () {
	default

	rm -f ChangeLog README.md LICENSE INSTALL

	insinto /usr/share/${PN}
	doins -r *
}
