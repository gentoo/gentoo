# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit autotools python-single-r1

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/OpenLightingProject/${PN}"
fi

DESCRIPTION="Open Lighting Architecture"
HOMEPAGE="https://www.openlighting.org/"

if [[ "${PV}" != "9999" ]]; then
	SRC_URI="https://github.com/OpenLightingProject/${PN}/releases/download/${PV}/${P}.tar.gz"
else
	SRC_URI=""
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="examples ftdi httpd osc python test usb"

RESTRICT="!test? ( test )"

# Since media-libs/liblo is not KEYWORDed for arm, we force-disable it
REQUIRED_USE="
	arm? ( !osc )
	arm64? ( !osc )
	python? ( ${PYTHON_REQUIRED_USE} )
"

# libmicrohttpd-0.9.68 enabled the "messages" functionality unconditionally and dropped the USE
RDEPEND="
	dev-libs/protobuf
	examples? ( sys-libs/ncurses )
	ftdi? ( dev-embedded/libftdi:* )
	httpd? ( || ( <net-libs/libmicrohttpd-0.9.68[messages] >=net-libs/libmicrohttpd-0.9.68 ) )
	!arm? (
		!arm64? (
			osc? ( media-libs/liblo )
		)
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/protobuf-python[${PYTHON_MULTI_USEDEP}]
		')
	)
	usb? ( virtual/libusb:1 )
"
DEPEND="
	${RDEPEND}
	dev-util/cppunit
"

if [[ "${PV}" != "9999" ]]; then
	PATCHES="
		"${FILESDIR}/0001-Eliminate_protobuf_AddDescriptors_call.patch"
		"${FILESDIR}/0002-Protobuf-3.11-compatibility.patch"
		"${FILESDIR}/0003-ncurses-6-compatibility.patch"
	"
fi

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf	--prefix=/usr \
		--disable-fatal-warnings \
		$(use_enable examples) \
		$(use_enable ftdi libftdi) \
		$(use_enable ftdi ftdidmx) \
		$(use_enable httpd http) \
		$(use_enable osc) \
		$(use_enable python python-libs) \
		$(use_enable usb libusb)
}

src_install() {
	default

	if use examples && use python; then
		docinto examples/python
		dodoc python/examples/*.py
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
