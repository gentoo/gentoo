# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/rebol-bin/rebol-bin-3_pre111.ebuild,v 1.2 2014/06/25 12:28:37 mgorny Exp $

EAPI=4
DESCRIPTION="Relative Expression-Based Object Language"
HOMEPAGE="http://rebol.com"

MY_PR=${PVR/3_pre/}
SRC_URI="http://www.rebol.com/r3/downloads/r3-a${MY_PR}-4-4.tar.gz"

inherit eutils

# sourcecode uses this license:
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

QA_PRESTRIPPED="opt/rebol/r3"

S=${WORKDIR}

src_compile() {
	:;
}

src_install() {
	mkdir -p "${D}/opt/rebol/"
	cp "${S}/r3" "${D}/opt/rebol/" 					|| die "Failed to install"
}
