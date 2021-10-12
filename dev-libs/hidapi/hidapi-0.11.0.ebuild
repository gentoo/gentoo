# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="A multi-platform library for USB and Bluetooth HID-Class devices"
HOMEPAGE="https://github.com/libusb/hidapi"
SRC_URI="https://github.com/libusb/hidapi/archive/${P}.tar.gz -> ${P}.tgz"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc fox"

RDEPEND="
	virtual/libusb:1[${MULTILIB_USEDEP}]
	virtual/libudev:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	fox? ( x11-libs/fox )"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${PN}-${PV}"

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

multilib_src_compile() {
	default
	if use doc && multilib_is_native_abi; then
		doxygen "${S}/doxygen/Doxyfile" || die
	fi
}

multilib_src_install() {
	default
	local HTML_DOCS
	if use doc && multilib_is_native_abi; then
		HTML_DOCS=( html/. )
	fi
	einstalldocs
}

multilib_src_install_all() {
	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
