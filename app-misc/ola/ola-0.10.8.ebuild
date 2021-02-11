# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

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
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="examples ftdi httpd python test usb"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	dev-libs/protobuf
	examples? ( sys-libs/ncurses )
	ftdi? ( dev-embedded/libftdi:* )
	httpd? ( net-libs/libmicrohttpd[messages(+)] )
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

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-fatal-warnings \
		--disable-osc \
		$(use_enable examples) \
		$(use_enable ftdi libftdi) \
		$(use_enable ftdi ftdidmx) \
		$(use_enable httpd http) \
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
