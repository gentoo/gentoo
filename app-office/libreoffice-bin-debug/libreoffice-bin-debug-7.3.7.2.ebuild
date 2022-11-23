# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BASE_PACKAGENAME="debug"
BASE_AMD64_URI="https://tamiko.43-1.org/distfiles/amd64-${BASE_PACKAGENAME}-"
BASE_X86_URI="https://tamiko.43-1.org/distfiles/x86-${BASE_PACKAGENAME}-"

DESCRIPTION="LibreOffice, a full office productivity suite. Binary package, debug info"
HOMEPAGE="https://www.libreoffice.org"
SRC_URI_AMD64="
	${BASE_AMD64_URI}libreoffice-${PVR}.tar.xz
	kde? (
		!java? ( ${BASE_AMD64_URI}libreoffice-kde-${PVR}.xd3 )
		java? ( ${BASE_AMD64_URI}libreoffice-kde-java-${PVR}.xd3 )
	)
	gnome? (
		!java? ( ${BASE_AMD64_URI}libreoffice-gnome-${PVR}.xd3 )
		java? ( ${BASE_AMD64_URI}libreoffice-gnome-java-${PVR}.xd3 )
	)
	!kde? ( !gnome? (
		java? ( ${BASE_AMD64_URI}libreoffice-java-${PVR}.xd3 )
	) )
"
SRC_URI_X86="
	${BASE_X86_URI}libreoffice-${PVR}.tar.xz
	kde? (
		${BASE_X86_URI}libreoffice-kde-${PVR}.xd3
	)
	gnome? (
		${BASE_X86_URI}libreoffice-gnome-${PVR}.xd3
	)
"

SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
	x86? ( ${SRC_URI_X86} )
"

IUSE="gnome java kde"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="-* amd64 ~x86"

# the = is correct, the debug info needs to fit the exact binary
RDEPEND="=app-office/${PN/-debug}-${PVR}[gnome=,java=,kde=]"

DEPEND="dev-util/xdelta:3"

RESTRICT="test strip"

S="${WORKDIR}"

QA_PREBUILT="/usr/*"

src_unpack() {
	einfo "Uncompressing distfile ${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar.xz"
	xz -cd "${DISTDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar.xz" > "${WORKDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar" || die

	use x86 && use java && die "There is no build for x86 with Java support."

	local patchname
	use kde && patchname="-kde"
	use gnome && patchname="-gnome"
	use java && patchname="${patchname}-java"

	if [[ -n "${patchname}" ]]; then
		einfo "Patching distfile ${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar using ${ARCH}-${BASE_PACKAGENAME}-libreoffice${patchname}-${PVR}.xd3"
		xdelta3 -d -s "${WORKDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar" "${DISTDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice${patchname}-${PVR}.xd3" "${WORKDIR}/tmpdist.tar" || die
		mv "${WORKDIR}/tmpdist.tar" "${WORKDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar" || die
	fi

	einfo "Unpacking new ${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar"
	unpack "./${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar"
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	dodir /usr
	cp -aR "${S}"/usr/* "${ED}"/usr/ || die
}
