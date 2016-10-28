# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="PAM module for executing scripts during authorization, password changes, and sessions"
HOMEPAGE="https://github.com/jeroennijhof/pam_script/"
SRC_URI="https://github.com/jeroennijhof/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="virtual/pam"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--libdir=/$(get_libdir)/security \
		--sysconfdir=/etc/security/${PN}
}

src_install() {
	default

	if use examples ; then
		docinto examples
		dodoc etc/README.examples
		exeinto /usr/share/doc/${PF}/examples
		doexe etc/{logscript,tally}
		docompress -x /usr/share/doc/${PF}/examples/{logscript,tally}
	fi
}
