# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/hidapi/hidapi-0.8.0_rc1_p20140201.ebuild,v 1.2 2014/11/30 09:30:55 mgorny Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit eutils versionator autotools-multilib #git-2

# If github is desired, the following may be used.
#EGIT_REPO_URI="git://github.com/signal11/hidapi.git"
#EGIT_BRANCH="master"
#EGIT_COMMIT="119135b8ce0e8db668ec171723d6e56d4394166a"

BASE_PV=$(get_version_component_range 1-3)
RC_PV=$(get_version_component_range 4)
GIT_PV=$(get_version_component_range 5)
GIT_PV=${GIT_PV/p/git}.3a66d4e

DEBIAN_PV=${BASE_PV}~${RC_PV}+${GIT_PV}+dfsg

# S is only needed for the debian_package
S=${WORKDIR}/${PN}-${DEBIAN_PV}

DESCRIPTION="A multi-platform library for USB and Bluetooth HID-Class devices"
HOMEPAGE="http://www.signal11.us/oss/hidapi/"
SRC_URI="mirror://debian/pool/main/h/${PN}/${PN}_${DEBIAN_PV}.orig.tar.bz2"
# When 0.8.0 is officially available the following link should be used.
#SRC_URI="mirror://github/signal11/${PN}/${P}.zip"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc static-libs X"

RDEPEND="virtual/libusb:1[${MULTILIB_USEDEP}]
	virtual/libudev:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	X? ( x11-libs/fox )"

src_prepare() {
	if use X && has_version x11-libs/fox:1.7 ; then
		sed -i -e 's:PKG_CHECK_MODULES(\[fox\], \[fox\]):PKG_CHECK_MODULES(\[fox\], \[fox17\]):' \
			configure.ac || die
	fi

	# Fix bashisms in the configure.ac file.
	sed -i -e 's:\([A-Z_]\+\)+="\(.*\)":\1="${\1}\2":g' \
		-e 's:\([A-Z_]\+\)+=`\(.*\)`:\1="${\1}\2":g' configure.ac || die

	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(multilib_native_use_enable X testgui)
	)

	autotools-utils_src_configure
}

src_compile() {
	autotools-multilib_src_compile

	if use doc; then
		doxygen doxygen/Doxyfile || die
	fi
}

src_install() {
	autotools-multilib_src_install

	if use doc; then
		dohtml -r html/.
	fi
}
