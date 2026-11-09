# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://git.code.sf.net/p/urjtag/git"
	inherit git-r3 autotools
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

DESCRIPTION="Tool for communicating over JTAG with flash chips, CPUs, and many more"
HOMEPAGE="https://urjtag.sourceforge.io/"

LICENSE="GPL-2"
SLOT="0"

IUSE="ftdi ftd2xx python readline usb"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="ftdi? ( dev-embedded/libftdi:1 )
	ftd2xx? ( dev-embedded/libftd2xx )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
	usb? ( virtual/libusb:1 )"
RDEPEND="${DEPEND}"
BDEPEND="
	python? ( ${DISTUTILS_DEPS} )
"

PATCHES=(
	"${FILESDIR}/${PN}-2021.03-fix-python-setup.patch"
)

src_prepare() {
	default

	if [[ ${PV} == "9999" ]] ; then
		mkdir -p m4 || die
		eautopoint
		eautoreconf
	fi

	if use python; then
		cd bindings/python || die
		distutils-r1_src_prepare
	fi
}

src_configure() {
	econf \
		--disable-werror \
		--disable-python \
		$(use_with readline) \
		$(use_with ftdi libftdi) \
		$(use_with ftd2xx) \
		$(use_with usb libusb 1.0)
}

src_compile() {
	default

	if use python; then
		cd bindings/python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	default

	if use python; then
		cd bindings/python || die
		distutils-r1_src_install
	fi

	find "${ED}" -name '*.la' -delete || die
}
