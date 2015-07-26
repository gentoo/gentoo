# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/libreoffice-bin/libreoffice-bin-4.4.4.3.ebuild,v 1.3 2015/07/22 19:34:03 ago Exp $

EAPI=5

KDE_REQUIRED="optional"
CMAKE_REQUIRED="never"

BASE_PACKAGENAME="bin"
BASE_AMD64_URI="http://packages.gentooexperimental.org/packages/amd64-libreoffice/amd64-${BASE_PACKAGENAME}-"
BASE_X86_URI="http://packages.gentooexperimental.org/packages/x86-libreoffice/x86-${BASE_PACKAGENAME}-"

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
PYTHON_REQ_USE="threads,xml"

inherit kde4-base java-pkg-opt-2 python-single-r1 pax-utils prefix versionator

DESCRIPTION="LibreOffice, a full office productivity suite. Binary package"
HOMEPAGE="http://www.libreoffice.org"
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
		!java? ( ${BASE_X86_URI}libreoffice-kde-${PVR}.xd3 )
		java? ( ${BASE_X86_URI}libreoffice-kde-java-${PVR}.xd3 )
	)
	gnome? (
		!java? ( ${BASE_X86_URI}libreoffice-gnome-${PVR}.xd3 )
		java? ( ${BASE_X86_URI}libreoffice-gnome-java-${PVR}.xd3 )
	)
	!kde? ( !gnome? (
		java? ( ${BASE_X86_URI}libreoffice-java-${PVR}.xd3 )
	) )
"

SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
	x86? ( ${SRC_URI_X86} )
"

IUSE="gnome java kde"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="-* amd64 x86"

BIN_COMMON_DEPEND="
	=app-text/libexttextcat-3.4*
	=app-text/libmwaw-0.3*
	app-text/poppler:0/51
	dev-libs/boost:0/1.56.0
	dev-libs/icu:0/55
	=media-gfx/graphite2-1.2*
	media-libs/glew:0/1.10
	media-libs/harfbuzz:0/0.9.18[icu]
	media-libs/libpng:0/16
	>=sys-libs/glibc-2.20-r2
	virtual/jpeg:62
	kde? ( >=kde-base/kdelibs-4.14.8:4 >=dev-qt/qtcore-4.8.6-r2:4 >=dev-qt/qtgui-4.8.6-r4:4 )
"

# PLEASE place any restrictions that are specific to the binary builds
# into the BIN_COMMON_DEPEND block above.
# All dependencies below this point should remain identical to those in
# the source ebuilds.

COMMON_DEPEND="
	${BIN_COMMON_DEPEND}
	${PYTHON_DEPS}
	app-arch/zip
	app-arch/unzip
	>=app-text/hunspell-1.3.2-r3
	app-text/mythes
	>=app-text/libabw-0.1.0
	>=app-text/libexttextcat-3.2
	>=app-text/libebook-0.1.1
	>=app-text/libetonyek-0.1.1
	app-text/liblangtag
	>=app-text/libmspub-0.1.0
	>=app-text/libmwaw-0.3.4
	>=app-text/libodfgen-0.1.0
	app-text/libwpd:0.10[tools]
	app-text/libwpg:0.3
	=app-text/libwps-0.3*
	>=app-text/poppler-0.16:=[xpdf-headers(+),cxx]
	>=dev-cpp/clucene-2.3.3.4-r2
	=dev-cpp/libcmis-0.5*
	dev-db/unixODBC
	>=dev-libs/boost-1.55:=
	dev-libs/expat
	>=dev-libs/hyphen-2.7.1
	>=dev-libs/icu-4.8.1.1:=
	=dev-libs/liborcus-0.7*
	>=dev-libs/librevenge-0.0.1
	>=dev-libs/nspr-4.8.8
	>=dev-libs/nss-3.12.9
	>=dev-lang/perl-5.0
	>=dev-libs/openssl-1.0.0d:0
	>=dev-libs/redland-1.0.16
	media-gfx/graphite2
	>=media-libs/fontconfig-2.8.0
	media-libs/freetype:2
	>=media-libs/glew-1.10
	>=media-libs/harfbuzz-0.9.18:=[icu(+)]
	media-libs/lcms:2
	>=media-libs/libpng-1.4:0=
	>=media-libs/libcdr-0.1.0
	>=media-libs/libfreehand-0.1.0
	media-libs/libpagemaker
	>=media-libs/libvisio-0.1.0
	>=net-misc/curl-7.21.4
	net-libs/neon
	net-nds/openldap
	sci-mathematics/lpsolve
	virtual/jpeg:0
	>=x11-libs/cairo-1.10.0[X]
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	virtual/glu
	virtual/opengl
	net-print/cups
	>=dev-libs/dbus-glib-0.92
	gnome? ( gnome-extra/evolution-data-server )
	gnome? ( gnome-base/gconf:2 )
	x11-libs/gdk-pixbuf[X]
	>=x11-libs/gtk+-2.24:2
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"

RDEPEND="${COMMON_DEPEND}
	!app-office/libreoffice
	!<app-office/openoffice-bin-3.4.0-r1
	!app-office/openoffice
	media-fonts/libertine
	media-fonts/liberation-fonts
	media-fonts/urw-fonts
	java? ( >=virtual/jre-1.6 )
	kde? ( $(add_kdeapps_dep kioclient) )
"

PDEPEND="
	=app-office/libreoffice-l10n-${PV}*
"

DEPEND="dev-util/xdelta:3"

# only one flavor at a time
REQUIRED_USE="kde? ( !gnome ) gnome? ( !kde )"

RESTRICT="test strip"

S="${WORKDIR}"

PYTHON_UPDATER_IGNORE="1"

pkg_pretend() {
	[[ $(gcc-major-version) -lt 4 ]] || \
			( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -le 4 ]] ) \
		&& die "Sorry, but gcc-4.4 and earlier won't work for libreoffice-bin package (see bug #387515)."
}

pkg_setup() {
	kde4-base_pkg_setup
}

src_unpack() {
	einfo "Uncompressing distfile ${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar.xz"
	xz -cd "${DISTDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar.xz" > "${WORKDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar" || die

	local patchname
	use kde && patchname="-kde"
	use gnome && patchname="-gnome"
	use java && patchname="${patchname}-java"

	if [ -n "${patchname}" ]; then
		einfo "Patching distfile ${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar using ${ARCH}-${BASE_PACKAGENAME}-libreoffice${patchname}-${PVR}.xd3"
		xdelta3 -d -s "${WORKDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar" "${DISTDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice${patchname}-${PVR}.xd3" "${WORKDIR}/tmpdist.tar" || die
		mv "${WORKDIR}/tmpdist.tar" "${WORKDIR}/${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar" || die
	fi

	einfo "Unpacking new ${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar"
	unpack "./${ARCH}-${BASE_PACKAGENAME}-libreoffice-${PVR}.tar"
}

src_prepare() {
	cp "${FILESDIR}"/50-${PN} "${T}"
	eprefixify "${T}"/50-${PN}
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	dodir /usr
	cp -aR "${S}"/usr/* "${ED}"/usr/

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${T}/50-${PN}"
}

pkg_preinst() {
	# Cache updates - all handled by kde eclass for all environments
	kde4-base_pkg_preinst
}

pkg_postinst() {
	kde4-base_pkg_postinst

	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/libreoffice/program/soffice.bin
	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/libreoffice/program/unopkg.bin

	use java || \
		ewarn 'If you plan to use lbase application you should enable java or you will get various crashes.'
}

pkg_postrm() {
	kde4-base_pkg_postrm
}
