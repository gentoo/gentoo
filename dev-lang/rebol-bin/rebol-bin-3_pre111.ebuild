# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	:
}

src_install() {
	mkdir -p "${D}/opt/rebol/"
	cp "${S}/r3" "${D}/opt/rebol/" || die "Failed to install"
}
