# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit eutils python-single-r1 java-pkg-opt-2

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="http://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="provide basic hardware drivers for logic analyzers and input/output file format support"
HOMEPAGE="http://sigrok.org/wiki/Libsigrok"

LICENSE="GPL-3"
SLOT="0"
IUSE="cxx ftdi java parport python serial static-libs test usb"
REQUIRED_USE="java? ( cxx ) python? ( cxx ${PYTHON_REQUIRED_USE} )"

# We also support librevisa, but that isn't in the tree ...
LIB_DEPEND=">=dev-libs/glib-2.32.0[static-libs(+)]
	>=dev-libs/libzip-0.8[static-libs(+)]
	cxx? ( dev-cpp/glibmm:2[static-libs(+)] )
	python? ( ${PYTHON_DEPS} >=dev-python/pygobject-3.0.0[${PYTHON_USEDEP}] )
	ftdi? ( >=dev-embedded/libftdi-0.16:=[static-libs(+)] )
	parport? ( sys-libs/libieee1284[static-libs(+)] )
	serial? ( >=dev-libs/libserialport-0.1.1[static-libs(+)] )
	usb? ( virtual/libusb:1[static-libs(+)] )"
RDEPEND="!static-libs? ( ${LIB_DEPEND//\[static-libs(+)]} )
	static-libs? ( ${LIB_DEPEND} )
	java? ( >=virtual/jre-1.4 )"
DEPEND="${LIB_DEPEND//\[static-libs(+)]}
	test? ( >=dev-libs/check-0.9.4 )
	cxx? ( app-doc/doxygen )
	java? (
		>=dev-lang/swig-3.0.6
		>=virtual/jdk-1.4
	)
	python? (
		>=dev-lang/swig-3.0.6
	)
	virtual/pkgconfig"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	eapply_user
}

src_configure() {
	econf \
		$(use_with ftdi libftdi) \
		$(use_with parport libieee1284) \
		$(use_with serial libserialport) \
		$(use_with usb libusb) \
		$(use_enable cxx) \
		$(use_enable java) \
		$(use_enable python) \
		--disable-ruby \
		$(use_enable static-libs static)
}

src_test() {
	emake check
}

src_install() {
	default
	prune_libtool_files
}
