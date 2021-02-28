# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

# If github is desired, the following may be used.
#EGIT_REPO_URI="https://github.com/signal11/hidapi.git"
#EGIT_BRANCH="master"
EGIT_COMMIT="d17db57b9d4354752e0af42f5f33007a42ef2906"

DESCRIPTION="A multi-platform library for USB and Bluetooth HID-Class devices"
HOMEPAGE="http://www.signal11.us/oss/hidapi/"
SRC_URI="https://github.com/signal11/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tgz"
# When 0.8.0 is officially available the following link should be used.
#SRC_URI="https://github.com/downloads/signal11/${PN}/${P}.zip"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="doc fox"

RDEPEND="
	virtual/libusb:1[${MULTILIB_USEDEP}]
	virtual/libudev:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	fox? ( x11-libs/fox )"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

PATCHES=( "${FILESDIR}"/${P}-autoconf-2.70.patch )

src_prepare() {
	default

	if ! use fox; then
		sed -i -e 's:PKG_CHECK_MODULES(\[fox\], .*):AC_SUBST(fox_CFLAGS,[ ])AC_SUBST(fox_LIBS,[ ]):' configure.ac || die
	fi

	# Fix bashisms in the configure.ac file.
	sed -i -e 's:\([A-Z_]\+\)+="\(.*\)":\1="${\1}\2":g' \
		-e 's:\([A-Z_]\+\)+=`\(.*\)`:\1="${\1}\2":g' configure.ac || die

	# Portage handles license texts itself, no need to install them
	sed -i -e 's/LICENSE.*/ # blank/' Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		$(multilib_native_use_enable fox testgui)
}

multilib_src_install_all() {
	if use doc; then
		doxygen doxygen/Doxyfile || die
		HTML_DOCS=( html/. )
	fi

	einstalldocs

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
