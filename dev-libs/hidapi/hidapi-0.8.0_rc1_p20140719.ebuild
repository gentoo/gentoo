# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit eutils versionator autotools-multilib #git-2

# If github is desired, the following may be used.
#EGIT_REPO_URI="git://github.com/signal11/hidapi.git"
#EGIT_BRANCH="master"
EGIT_COMMIT="d17db57b9d4354752e0af42f5f33007a42ef2906"

# S is only needed for the debian_package
S=${WORKDIR}/${PN}-${DEBIAN_PV}

DESCRIPTION="A multi-platform library for USB and Bluetooth HID-Class devices"
HOMEPAGE="http://www.signal11.us/oss/hidapi/"
SRC_URI="https://github.com/signal11/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tgz"
# When 0.8.0 is officially available the following link should be used.
#SRC_URI="mirror://github/signal11/${PN}/${P}.zip"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="doc fox static-libs"

RDEPEND="virtual/libusb:1[${MULTILIB_USEDEP}]
	virtual/libudev:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	fox? ( x11-libs/fox )"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	if ! use fox; then
		sed -i -e 's:PKG_CHECK_MODULES(\[fox\], .*):AC_SUBST(fox_CFLAGS,[ ])AC_SUBST(fox_LIBS,[ ]):' configure.ac || die
	fi

	# Fix bashisms in the configure.ac file.
	sed -i -e 's:\([A-Z_]\+\)+="\(.*\)":\1="${\1}\2":g' \
		-e 's:\([A-Z_]\+\)+=`\(.*\)`:\1="${\1}\2":g' configure.ac || die

	# Portage handles license texts itself, no need to install them
	sed -i -e 's/LICENSE.*/ # blank/' Makefile.am || die

	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(multilib_native_use_enable fox testgui)
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
