# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools python-single-r1

DESCRIPTION="Open Lighting Architecture, a framework for lighting control information"
HOMEPAGE="https://www.openlighting.org/ola/"
SRC_URI="https://github.com/OpenLightingProject/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples ftdi http osc python rdm-tests tcmalloc test usb zeroconf"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	rdm-tests? ( python )"

RESTRICT="!test? ( test )"

RDEPEND="dev-libs/protobuf:=
	sys-apps/util-linux
	sys-libs/ncurses
	ftdi? ( dev-embedded/libftdi:1 )
	http? ( net-libs/libmicrohttpd:= )
	osc? ( media-libs/liblo )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/protobuf-python[${PYTHON_USEDEP}]
		')
	)
	rdm-tests? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	tcmalloc? ( dev-util/google-perftools:= )
	usb? ( virtual/libusb:1 )
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"
BDEPEND="sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	test? (
		dev-util/cppunit
		python? (
			${PYTHON_DEPS}
			$(python_gen_cond_dep '
				dev-python/numpy[${PYTHON_USEDEP}]
				dev-python/protobuf-python[${PYTHON_USEDEP}]
			')
		)
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.8-python_version_check.patch
)

src_prepare() {
	default
	# Upstream recommends doing this even for tarball builds
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-fatal-warnings
		--with-uucp-lock="/run"
		$(use_enable examples)
		$(use_enable ftdi libftdi)
		$(use_enable http)
		$(use_enable osc)
		$(use_enable python python-libs)
		$(use_enable rdm-tests)
		$(use_enable tcmalloc)
		$(use_enable test unittests)
		$(use_enable usb libusb)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	if use examples && use python; then
		docinto examples
		python_fix_shebang python/examples/*.py
		dodoc python/examples/*.py
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
