# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base udev

MY_P="Argyll_V${PV}"
DESCRIPTION="Open source, ICC compatible color management system"
HOMEPAGE="http://www.argyllcms.com/"
SRC_URI="http://www.argyllcms.com/${MY_P}_src.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="media-libs/tiff
	virtual/jpeg
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXxf86vm
	x11-libs/libXScrnSaver"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/ftjam"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-1.4.0-jpeg.patch"
	"${FILESDIR}/${PN}-1.4.0-CVE-2012-4405.patch" )

src_compile() {
	# Make it respect LDFLAGS
	echo "LINKFLAGS += ${LDFLAGS} ;" >> Jamtop

	# Evil hack to get --as-needed working. The build system unfortunately lists all
	# the shared libraries by default on the command line _before_ the object to be built...
	echo "STDLIBS += -ldl -lrt -lX11 -lXext -lXxf86vm -lXinerama -lXrandr -lXau -lXdmcp -lXss -ltiff -ljpeg ;" >> Jamtop

	local jobnumber=$(echo "${MAKEOPTS}" | sed -ne "/-j/ { s/.*\(-j[[:space:]]*[0-9]\+\).*/\1/; p }")
	[ ${jobnumber} ] || jobnumber=-j1

	jam -q -fJambase ${jobnumber} || die
}

src_install() {
	jam -q -fJambase install || die

	rm bin/License.txt || die

	cd bin || die
	local binname
	for binname in * ; do
		newbin ${binname} argyll-${binname}
	done
	cd .. || die

	if use doc; then
		dohtml doc/*
	fi

	dodoc log.txt Readme.txt ttbd.txt notes.txt

	insinto /usr/share/${PN}/ref
	doins   ref/*

	udev_dorules libusb/55-Argyll.rules
}

pkg_postinst() {
	elog "If you have a Spyder2 you need to extract the firmware"
	elog "from the CVSpyder.dll of the windows driver package"
	elog "and store it as /usr/share/color/spyd2PLD.bin"
	elog
	elog "For further info on setting up instrument access read"
	elog "http://www.argyllcms.com/doc/Installing_Linux.html"
	elog
}
