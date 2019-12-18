# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

MY_PV=$(ver_rs 3 '-')

DESCRIPTION="Proprietary image-support library for Radeon Open Compute"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm#closed-source-components"
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/h/${PN}-dev/${PN}-dev_${MY_PV}-g0d1ca36_amd64.deb"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-deprecated"

RESTRICT="bindist strip"

QA_PREBUILT="/opt/${PN}/lib*/*"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	local destdir="/opt/${PN}"
	local soversion=$(ver_cut 1-3)
	local somajor=$(ver_cut 1)

	local solibs_to_install=( "libhsa-ext-image64.so" )
	if use deprecated; then
		solibs_to_install+=( "libhsa-runtime-tools64.so" )
	fi

	into "${destdir}"
	for solib in ${solibs_to_install[@]}; do
		dolib.so "opt/rocm/hsa/lib/${solib}.${soversion}"
		dosym "${EPREFIX}${destdir}/$(get_libdir)/${solib}.${soversion}" "${EPREFIX}usr/$(get_libdir)/${solib}.${soversion}"
		dosym "${solib}.${soversion}" "${EPREFIX}usr/$(get_libdir)/${solib}.${somajor}"
	done
}
