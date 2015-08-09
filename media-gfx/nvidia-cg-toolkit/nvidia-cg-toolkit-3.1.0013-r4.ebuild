# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit eutils multilib multilib-minimal prefix versionator

MY_PV="$(get_version_component_range 1-2)"
MY_DATE="April2012"

DESCRIPTION="NVIDIA's C graphics compiler toolkit"
HOMEPAGE="http://developer.nvidia.com/cg_toolkit"
SRC_URI="
	abi_x86_32? (
		http://developer.download.nvidia.com/cg/Cg_${MY_PV}/Cg-${MY_PV}_${MY_DATE}_x86.tgz
	)
	abi_x86_64? (
		http://developer.download.nvidia.com/cg/Cg_${MY_PV}/Cg-${MY_PV}_${MY_DATE}_x86_64.tgz
	)"

LICENSE="NVIDIA-r1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples multilib"

REQUIRED_USE="amd64? ( multilib? ( abi_x86_32 ) )"

RESTRICT="strip"

RDEPEND="
	media-libs/glu
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	virtual/opengl
	amd64? (
		abi_x86_32? (
			>=media-libs/freeglut-2.8.1[abi_x86_32(-)]
			>=media-libs/glu-9.0.0-r1[abi_x86_32(-)]
			>=virtual/opengl-7.0-r1[abi_x86_32(-)]
			>=x11-libs/libICE-1.0.8-r1[abi_x86_32(-)]
			>=x11-libs/libSM-1.2.1-r1[abi_x86_32(-)]
			>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
			>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
			>=x11-libs/libXi-1.7.2[abi_x86_32(-)]
			>=x11-libs/libXmu-1.1.1-r1[abi_x86_32(-)]
			>=x11-libs/libXt-1.1.4[abi_x86_32(-)]
		)
	)"
DEPEND=""

S=${WORKDIR}

DEST=/opt/${PN}

QA_PREBUILT="${DEST}/.* /usr/share/.*"

src_unpack() {
	multilib_src_unpack() {
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" || die

		local i
		for i in ${A}; do
			if [[ ${i} == *x86_64* && ${ABI} == amd64 ]]; then
				unpack "${i}"
			elif [[ ${i} != *x86_64* && ${ABI} != amd64 ]]; then
				unpack "${i}"
			fi
		done
	}

	multilib_foreach_abi multilib_src_unpack
}

install_pkgconfig() {
	# One arg: .pc file
	insinto /usr/$(get_libdir)/pkgconfig
	sed \
		-e "s:GENTOO_LIBDIR:$(get_libdir):g" \
		-e "s:DESCRIPTION:${DESCRIPTION}:g" \
		-e "s:VERSION:${PV}:g" \
		-e "s|HOMEPAGE|${HOMEPAGE}|g" \
		-e "s:SUFFIX::g" \
		"${FILESDIR}/${1}.in" > "${T}/${1}" || die
		eprefixify "${T}/${1}"
	doins "${T}/${1}"
}

src_install() {
	local LDPATH=()

	multilib-minimal_src_install
}

multilib_src_install() {
	LDPATH+=( "${EPREFIX}${DEST}/$(get_libdir)" )
	into ${DEST}

	if [[ ${ABI} == amd64 ]]; then
		dolib usr/lib64/*
	else
		dolib usr/lib/*
	fi
	install_pkgconfig nvidia-cg-toolkit.pc
	install_pkgconfig nvidia-cg-toolkit-gl.pc

	insinto ${DEST}/include
	doins -r usr/include/Cg

	if multilib_is_native_abi; then
		dobin usr/bin/{cgc,cgfxcat,cginfo}

		insinto ${DEST}
		dodoc usr/local/Cg/README
		if use doc; then
			DOCS=( usr/local/Cg/docs/*.{txt,pdf} )
			HTML_DOCS=( usr/local/Cg/docs/html/. )
			einstalldocs
		fi
		if use examples; then
			dodir /usr/share/${PN}
			mv usr/local/Cg/examples "${ED}"/usr/share/${PN}/
		fi
	fi
}

multilib_src_install_all() {
	local ldpath=${LDPATH[*]}

	sed \
		-e "s|ELDPATH|${ldpath// /:}|g" \
		"${FILESDIR}"/80cgc-opt-2 > "${T}"/80cgc-opt || die
	eprefixify "${T}"/80cgc-opt
	doenvd "${T}"/80cgc-opt
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} < 2.1.0016 ]]; then
		einfo "Starting with ${CATEGORY}/${PN}-2.1.0016, ${PN} is installed in"
		einfo "${DEST}. Packages might have to add something like:"
		einfo "  append-cppflags -I${DEST}/include"
	fi
}
