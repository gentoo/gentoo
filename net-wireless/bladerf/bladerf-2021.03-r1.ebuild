# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic udev

DESCRIPTION="Libraries for supporing the BladeRF hardware from Nuand"
HOMEPAGE="https://nuand.com/"

#lib is LGPL and cli tools are GPL
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/${PV}"

#maintainer notes:
#doc use flag, looks like it can't be disabled right now and will
#	always build if pandoc and help2man are installed
#	also ignores when deps are missing and just disables docs
IUSE="doc +tecla"

MY_PN="bladeRF"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Nuand/${MY_PN}.git"
else
	MY_PV=${PV/\_/-}
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	SRC_URI="https://github.com/Nuand/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz \
			https://github.com/analogdevicesinc/no-OS/archive/0bba46e6f6f75785a65d425ece37d0a04daf6157.tar.gz -> analogdevices-no-OS-0bba46.tar.gz"
	KEYWORDS="amd64 ~arm ~riscv x86"
fi

BDEPEND="doc? ( app-text/doxygen )"
CDEPEND=">=dev-libs/libusb-1.0.16:1
	tecla? ( dev-libs/libtecla )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	>=net-wireless/bladerf-firmware-2.4.0
	>=net-wireless/bladerf-fpga-0.12.0"

src_unpack() {
	if [ "${PV}" = "9999" ]; then
		git-r3_src_unpack
	else
		default
		mv "${WORKDIR}/no-OS-0bba46e6f6f75785a65d425ece37d0a04daf6157/ad9361" "${S}/thirdparty/analogdevicesinc/no-OS/" || die
	fi
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/861872
	# https://github.com/Nuand/bladeRF/issues/903
	filter-lto

	local mycmakeargs=(
		-DVERSION_INFO_OVERRIDE:STRING="${PV}"
		-DBUILD_DOCUMENTATION="$(usex doc)"
		-DENABLE_LIBTECLA="$(usex tecla)"
		-DTREAT_WARNINGS_AS_ERRORS=OFF
		-DUDEV_RULES_PATH="$(get_udevdir)"/rules.d
	)
	cmake_src_configure
}

pkg_postinst() {
	udev_reload
}
pkg_postrm() {
	udev_reload
}
