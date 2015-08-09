# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
WEBAPP_MANUAL_SLOT="yes"
inherit webapp eutils

DESCRIPTION="Web frontend for sys-cluster/ganglia"
HOMEPAGE="http://ganglia.sourceforge.net"
SRC_URI="mirror://sourceforge/ganglia/${PN}/${PV}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="vhosts"

DEPEND="net-misc/rsync"
RDEPEND="
	${DEPEND}
	${WEBAPP_DEPEND}
	>=sys-cluster/ganglia-3.3.7[-minimal]
	dev-lang/php[gd,xml,ctype,cgi]
	media-fonts/dejavu"

src_configure() {
	return 0
}

src_compile() {
	return 0
}

src_prepare() {
	epatch "${FILESDIR}"/CVE-2013-6395-fix-xss.patch
}

src_install() {
	webapp_src_preinst
	cd "${S}"
	emake \
		GDESTDIR="${MY_HTDOCSDIR}" \
		DESTDIR="${D}" \
		APACHE_USER=nobody \
		install || die
	webapp_configfile "${MY_HTDOCSDIR}"/conf_default.php
	webapp_src_install

	fowners -R nobody:nobody /var/lib/ganglia-web/dwoo
	fperms -R 777 /var/lib/ganglia-web/dwoo

	dodoc AUTHORS README TODO || die
}

pkg_postinst() {
	webapp_pkg_postinst

	# upgrade from < 3.5.6
	if [ -d "${ROOT}"/var/lib/ganglia/dwoo ]; then
		rm -rf "${ROOT}"/var/lib/ganglia/dwoo || die
	fi
}
