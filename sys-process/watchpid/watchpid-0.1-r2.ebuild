# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="Watches a process for termination"
SRC_URI="mirror://gentoo/${PN}_${PV}.tar.gz"
HOMEPAGE="http://www.codepark.org/"
KEYWORDS="amd64 ppc x86"

SLOT="0"
LICENSE="GPL-2"

DOCS=( README AUTHORS )

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

src_compile() {
	multilib-minimal_src_compile
}

src_install() {
	multilib-minimal_src_install
}
