# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-multilib

MY_P="deviceatlas-enterprise-c-${PV}"

DESCRIPTION="API to detect devices based on the User-Agent HTTP header"
HOMEPAGE="https://deviceatlas.com"
SRC_URI="${MY_P}.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc examples"

RDEPEND="dev-libs/libpcre[${MULTILIB_USEDEP}]"

RESTRICT="fetch mirror bindist"

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	eerror "Please go to https://deviceatlas.com/deviceatlas-haproxy-module"
	eerror "And download DeviceAtlas C API"
	eerror "Then place the file in ${DISTDIR}/${MY_P}.tgz"
}

multilib_src_install_all() {
	if use doc ; then
		local -a HTML_DOCS=( Documentation )
	fi

	if use examples ; then
		insinto /usr/share/doc/${P}/examples
		doins Examples/daexutil.h
		doins Examples/example{0,1,2,3,4}.c
		doins Examples/util.c
		doins Examples/EXAMPLES.USAGE
	fi

	einstalldocs
}
