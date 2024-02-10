# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.code.sf.net/p/urjtag/git"
	inherit git-r3 autotools
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="mirror://sourceforge/urjtag/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

DESCRIPTION="Tool for communicating over JTAG with flash chips, CPUs, and many more"
HOMEPAGE="https://urjtag.sourceforge.net/"

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
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
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
	use python && python_copy_sources

	emake
}

src_install() {
	default

	if use python; then
		installation() {
			cd bindings/python || die
			ln -s "${S}"/src/.libs ../../src/.libs || die
			"${EPYTHON}" setup.py install \
				--root="${D}" \
				--prefix="${EPREFIX}/usr" || die
		}
		python_foreach_impl run_in_build_dir installation
		python_foreach_impl python_optimize
	fi

	find "${ED}" -name '*.la' -delete || die
}
