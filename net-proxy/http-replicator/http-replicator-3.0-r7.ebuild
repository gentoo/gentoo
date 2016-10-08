# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 ) # not 2.6 bug #33907, not 3.0 bug #411083
inherit eutils python-single-r1 systemd

MY_P="${PN}_${PV}"

DESCRIPTION="Proxy cache for Gentoo packages"
HOMEPAGE="https://sourceforge.net/projects/http-replicator"
SRC_URI="mirror://sourceforge/http-replicator/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~sparc x86"

PATCHES=(
	"${FILESDIR}/http-replicator-3.0-sighup.patch"
	"${FILESDIR}/http-replicator-3-unique-cache-name.patch"
	"${FILESDIR}/http-replicator-3-missing-directory.patch"
)

src_install(){
	python-single-r1_pkg_setup

	# Daemon and repcacheman into /usr/bin
	python_scriptinto /usr/bin
	python_doscript http-replicator
	python_newscript "${FILESDIR}/http-replicator-3.0-repcacheman-0.44-r2" repcacheman.py

	exeinto /usr/bin
	newexe "${FILESDIR}/http-replicator-3.0-callrepcacheman-0.1" repcacheman

	# init.d scripts
	newinitd "${FILESDIR}/http-replicator-3.0.init" http-replicator
	newconfd "${FILESDIR}/http-replicator-3.0.conf" http-replicator

	systemd_dounit "${FILESDIR}"/http-replicator.service
	systemd_install_serviced "${FILESDIR}"/http-replicator.service.conf

	# Docs
	dodoc README debian/changelog

	# Man Page - Not Gentooified yet
	doman http-replicator.1

	insinto /etc/logrotate.d
	newins debian/logrotate http-replicator
}

pkg_postinst() {
	elog
	ewarn "Before starting http-replicator, please follow the next few steps:"
	elog "- Modify /etc/conf.d/http-replicator if required."
	ewarn "- Run /usr/bin/repcacheman to set up the cache."
	elog "- Add http_proxy=\"http://serveraddress:8080\" to make.conf on"
	elog "  the server as well as on the client machines."
	elog "- Make sure FETCHCOMMAND adds the X-unique-cache-name header to"
	elog "  HTTP requests in make.conf (or maybe portage will add it to"
	elog "  the default make.globals someday).  Example:"
	elog '   FETCHCOMMAND="wget -t 3 -T 60 --passive-ftp -O \"\${DISTDIR}/\${FILE}\" --header=\"X-unique-cache-name: \${FILE}\" \"\${URI}\""'
	elog '   RESUMECOMMAND="wget -c -t 3 -T 60 --passive-ftp -O \"\${DISTDIR}/\${FILE}\" --header=\"X-unique-cache-name: \${FILE}\" \"\${URI}\""'
	elog "- Arrange to periodically run repcacheman on this server,"
	elog "  to clean up the local /usr/portage/distfiles directory."
	elog "- Arrange to periodically run something like the following"
	elog "  on this server.  'eclean' is in app-portage/gentoolkit."
	elog "    ( export DISTDIR=/var/cache/http-replicator/"
	elog "      eclean -i distfiles )"
	elog "- Even with FETCHCOMMAND fixing most cases, occasionally"
	elog "  an older invalid version of a file may end up in the cache,"
	elog "  causing checksum failures when portage tries to fetch"
	elog "  it.  To recover, either use eclean (above), manually delete"
	elog "  the relevant file from the cache, or temporarily comment"
	elog "  out the http_proxy setting.  Commenting only requires"
	elog "  access to client config, not server cache."
	elog "- Make sure GENTOO_MIRRORS in /etc/portage/make.conf starts"
	elog "  with several good http mirrors."
	elog
	elog "For more information please refer to the following forum thread:"
	elog "  http://forums.gentoo.org/viewtopic-t-173226.html"
	elog
}
