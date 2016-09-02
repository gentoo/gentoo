# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Official binary Qt SoulSeek client"
HOMEPAGE="http://www.soulseekqt.net/"
BINARY_NAME="SoulseekQt-${PV:0:4}-$((${PV:4:2}))-$((${PV:6:2}))"
SRC_URI="
	x86? ( https://www.dropbox.com/s/7majmb4o5f2pg17/${BINARY_NAME}-32bit.tgz )
	amd64? ( https://www.dropbox.com/s/h26bzezec5vjcu3/${BINARY_NAME}-64bit.tgz )
"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="media-libs/libpng x11-libs/libX11 x11-libs/libxcb media-libs/freetype x11-libs/libXau x11-libs/libXdmcp dev-libs/libbsd dev-libs/expat"

S="${WORKDIR}"

RESTRICT="mirror"

QA_PREBUILT="opt/bin/.*"

src_install() {
	use amd64 && BINARY_NAME="${BINARY_NAME}-64bit"
	use x86 && BINARY_NAME="${BINARY_NAME}-32bit"
	into /opt
	newbin "${BINARY_NAME}" "${PN}"
}
