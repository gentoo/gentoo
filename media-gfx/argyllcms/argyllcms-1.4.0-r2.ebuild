# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/argyllcms/argyllcms-1.4.0-r2.ebuild,v 1.3 2013/12/06 00:21:03 voyageur Exp $

EAPI=5

inherit base flag-o-matic multiprocessing toolchain-funcs udev

MY_P="Argyll_V${PV}"

DESCRIPTION="Open source, ICC compatible color management system"
HOMEPAGE="http://www.argyllcms.com/"
SRC_URI="http://www.argyllcms.com/${MY_P}_src.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	media-libs/tiff
	sys-libs/zlib
	virtual/jpeg
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

PATCHES=(
	"${FILESDIR}/${PN}-1.4.0-jpeg.patch"
	"${FILESDIR}/${PN}-1.4.0-CVE-2012-4405.patch"
	)

src_compile() {
	# Make it respect LDFLAGS
	echo "LINKFLAGS += ${LDFLAGS} ;" >> Jamtop

	# Evil hack to get --as-needed working. The build system unfortunately lists all
	# the shared libraries by default on the command line _before_ the object to be built...
	echo "STDLIBS += -ldl -lrt -lX11 -lXext -lXxf86vm -lXinerama -lXrandr -lXau -lXdmcp -lXss -ltiff -ljpeg ;" >> Jamtop

	append-cflags -DUNIX -D_THREAD_SAFE

	sed \
		-e 's:CCFLAGS:CFLAGS:g' \
		-e "s:ar rusc:$(tc-getAR) rusc:g" \
		-i Jambase || die

	tc-export CC RANLIB

	jam -dx -fJambase "-j$(makeopts_jobs)" || die
}

src_install() {
	jam -dx -fJambase install || die

	rm bin/License.txt || die

	pushd bin > /dev/null
	local binname
	for binname in * ; do
		newbin ${binname} argyll-${binname}
	done
	popd > /dev/null

	use doc && dohtml doc/*

	dodoc log.txt Readme.txt ttbd.txt notes.txt

	insinto /usr/share/${PN}
	doins -r ref

	udev_dorules libusb/55-Argyll.rules
}

pkg_postinst() {
	elog "If you have a Spyder2 you need to extract the firmware"
	elog "from the CVSpyder.dll of the windows driver package"
	elog "and store it as /usr/share/color/spyd2PLD.bin"
	echo
	elog "For further info on setting up instrument access read"
	elog "http://www.argyllcms.com/doc/Installing_Linux.html"
	echo
}
