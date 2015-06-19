# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libhid/libhid-0.2.16-r4.ebuild,v 1.2 2014/12/28 19:11:47 floppym Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit autotools eutils python-single-r1

DESCRIPTION="Provides a generic and flexible way to access and interact with USB HID devices"
HOMEPAGE="http://libhid.alioth.debian.org/"
SRC_URI="http://beta.magicaltux.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc python static-libs"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
	virtual/libusb:0
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig )
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-swig.patch
	epatch "${FILESDIR}"/${P}-libusb.patch

	eautoreconf
}

src_configure() {
	export OS_LDFLAGS="${LDFLAGS}"
	use python && export PYTHON_LDFLAGS=$(${EPYTHON}-config --ldflags)

	econf \
		$(use_enable python swig) \
		$(use_enable static-libs static) \
		$(use_with doc doxygen) \
		--disable-debug \
		--disable-werror
}

DOCS=( AUTHORS ChangeLog NEWS README README.licence TODO )

src_install() {
	default

	use doc && dohtml -r doc/html/*

	prune_libtool_files
}
