# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user

DESCRIPTION="Network Management and Monitoring System"
HOMEPAGE="http://www.jffnms.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres snmp"

RDEPEND="
	dev-lang/php[apache2,cli,gd,mysql?,postgres?,session,snmp,sockets,wddx]
	dev-php/PEAR-PEAR
	media-gfx/graphviz
	media-libs/gd
	net-analyzer/fping
	net-analyzer/net-snmp
	net-analyzer/nmap
	net-analyzer/rrdtool[graph]
	sys-apps/diffutils
"

pkg_setup() {
	enewgroup jffnms
	enewuser jffnms -1 /bin/bash -1 jffnms,apache
}

src_install(){
	local INSTALL_DIR="/opt/${PN}"
	local IMAGE_DIR="${D}${INSTALL_DIR}"

	insinto "${INSTALL_DIR}"
	doins -r *

	rm -f "${IMAGE_DIR}/LICENSE"

	# Clean up Windows related stuff
	rm -f "${IMAGE_DIR}"/*.win32.txt
	rm -rf "${IMAGE_DIR}"/docs/windows
	rm -rf "${IMAGE_DIR}"/engine/windows

	fowners -R jffnms:apache "${INSTALL_DIR}"
	fperms -R ug+rw "${INSTALL_DIR}"
}

pkg_postinst() {
	elog "${PN} has been partialy installed on your system. However you"
	elog "still need proceed with final installation and configuration."
	elog "You can visit https://wiki.gentoo.org/wiki/Jffnms in order"
	elog "to get detailed information on how to get jffnms up and running."
}
