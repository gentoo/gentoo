# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A remote security scanner"
HOMEPAGE="http://www.nessus.org/"
SRC_URI=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="
	~net-analyzer/nessus-libraries-${PV}
	~net-analyzer/libnasl-${PV}
	~net-analyzer/nessus-core-${PV}
	~net-analyzer/nessus-plugins-${PV}"

pkg_postinst() {
	elog "The following article may be useful to get started:"
	elog "http://www.securityfocus.com/infocus/1741"
}

pkg_postrm() {
	elog "Note: this is a META ebuild for ${P}."
	elog "to remove it completely or before re-emerging"
	elog "either use 'depclean', or remove/re-emerge these packages:"
	elog
	for dep in ${RDEPEND}; do
		elog "     ${dep}"
	done
	echo
}
