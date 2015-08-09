# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic systemd toolchain-funcs user

MY_P="s${P}"

DESCRIPTION="Fork of thttpd, a small, fast, multiplexing webserver"
HOMEPAGE="http://opensource.dyc.edu/sthttpd"
SRC_URI="http://opensource.dyc.edu/pub/sthttpd/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND=""

WEBROOT="/var/www/localhost"

THTTPD_USER=thttpd
THTTPD_GROUP=thttpd
THTTPD_DOCROOT="${EPREFIX}${WEBROOT}/htdocs"

DOCS=( README TODO )

pkg_setup() {
	ebegin "Creating thttpd user and group"
	enewgroup ${THTTPD_GROUP}
	enewuser ${THTTPD_USER} -1 -1 -1 ${THTTPD_GROUP}
}

src_prepare () {
	epatch "${FILESDIR}"/thttpd-fix-world-readable-log.patch
}

src_configure() {
	econf WEBDIR=${THTTPD_DOCROOT}
}

src_install () {
	default

	newinitd "${FILESDIR}"/thttpd.init.1 thttpd
	newconfd "${FILESDIR}"/thttpd.confd.1 thttpd

	insinto /etc/logrotate.d
	newins "${FILESDIR}/thttpd.logrotate" thttpd

	insinto /etc/thttpd
	doins "${FILESDIR}"/thttpd.conf.sample

	systemd_dounit "${FILESDIR}/${PN}.service"

	#move htdocs to docdir, bug #429632
	docompress -x /usr/share/doc/"${PF}"/htdocs.dist
	mv "${ED}"${WEBROOT}/htdocs \
		"${ED}"/usr/share/doc/"${PF}"/htdocs.dist
	mkdir "${ED}"${WEBROOT}/htdocs

	keepdir ${WEBROOT}/htdocs

	chown root:${THTTPD_GROUP} "${ED}/usr/sbin/makeweb" \
		|| die "Failed chown makeweb"
	chmod 2751 "${ED}/usr/sbin/makeweb" \
		|| die "Failed chmod makeweb"
	chmod 755 "${ED}/usr/share/doc/${PF}/htdocs.dist/cgi-bin/printenv" \
		|| die "Failed chmod printenv"
}
