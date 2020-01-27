# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a highly configurable program for managing and archiving log files"
HOMEPAGE="http://www.weird.com/~woods/projects/newsyslog.html"
SRC_URI="ftp://ftp.weird.com/pub/local/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~mips ppc ppc64 ~sparc x86"

DEPEND="sys-apps/groff"

RDEPEND="
	virtual/cron
	app-arch/gzip"

PATCHES=( "${FILESDIR}/${P}-html.patch" )

DOCS=( newsyslog.conf AUTHORS ChangeLog INSTALL NEWS ToDo )

src_configure() {
	local myconf="--with-syslogd_pid=/var/run/syslog.pid"

	has_version 'app-admin/syslog-ng' \
	    && myconf="--with-syslogd_pid=/var/run/syslog-ng.pid"

	econf \
	    --with-gzip \
	    --with-newsyslog_conf=/etc/newsyslog.conf \
	    ${myconf}
}

src_install() {
	emake \
		DESTDIR="${D}" \
		catmandir="${T}"/dont-install \
		install
	einstalldocs
}
