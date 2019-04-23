# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit versionator unpacker udev multilib-minimal

MY_PV_1=$(get_major_version)
MY_PV_12=$(get_version_component_range 1-2)

DESCRIPTION="SDRplay API/HW driver for all RSPs"
HOMEPAGE="https://www.sdrplay.com"
SRC_URI="http://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${PV}.run"

LICENSE="SDRplay"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libusb:1
	virtual/udev"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="usr/lib64/libmirsdrapi-rsp.so.${MY_PV_12}
usr/lib32/libmirsdrapi-rsp.so.${MY_PV_12}"

multilib_src_install_all() {
	insinto /usr/include/
	doins mirsdrapi-rsp.h

	udev_dorules 66-mirics.rules
	udev_reload
}

multilib_src_install() {
	if [ "${MULTILIB_ABI_FLAG}" = "abi_x86_32" ]; then
		dolib "${S}/i686/libmirsdrapi-rsp.so.${MY_PV_12}"
	fi

	if [ "${MULTILIB_ABI_FLAG}" = "abi_x86_64" ]; then
		dolib "${S}/x86_64/libmirsdrapi-rsp.so.${MY_PV_12}"
	fi

	dosym libmirsdrapi-rsp.so.${MY_PV_12} "${EROOT}usr/$(get_libdir)/libmirsdrapi-rsp.so.${MY_PV_1}"
	dosym libmirsdrapi-rsp.so.${MY_PV_1} "${EROOT}usr/$(get_libdir)/libmirsdrapi-rsp.so"
}
