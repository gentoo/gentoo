# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils java-pkg-2 java-ant-2 toolchain-funcs java-osgi

MY_PV="${PV/_rc/RC}"
MY_DMF="download.eclipse.org/eclipse/downloads/drops/R-${MY_PV}-201009090800"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="GTK based SWT Library"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="x86? (
			http://${MY_DMF}/${MY_P}-gtk-linux-x86.zip
		)
		x86-fbsd? (
			http://${MY_DMF}/${MY_P}-gtk-linux-x86.zip
		)
		amd64? (
			http://${MY_DMF}/${MY_P}-gtk-linux-x86_64.zip
		)
		ppc? (
			http://${MY_DMF}/${MY_P}-gtk-linux-ppc.zip
		)
		ppc64? (
			http://${MY_DMF}/${MY_P}-gtk-linux-x86_64.zip
		)"

SLOT="3.6"
LICENSE="CPL-1.0 LGPL-2.1 MPL-1.1"
KEYWORDS="amd64 ppc64 x86"

IUSE="cairo gnome opengl"
COMMON=">=dev-libs/glib-2.6
		>=x11-libs/gtk+-2.6.8:2
		>=dev-libs/atk-1.10.2
		cairo? ( >=x11-libs/cairo-1.4.14 )
		gnome?	(
				=gnome-base/libgnome-2*
				=gnome-base/gnome-vfs-2*
				=gnome-base/libgnomeui-2*
				)
		opengl?	(
			virtual/opengl
			virtual/glu
		)
		x11-libs/libXtst"

# Use a blocker to avoid file collisions when upgrading to the slotted version
# We cannot use slotmove, java packages are expected to be in /usr/share/PN-SLOT
# so this is the only way to prevent collisions
# libXtst/xextproto is done like this due to the XTest.h move - bug #292244

DEPEND=">=virtual/jdk-1.4
		app-arch/unzip
		x11-libs/libX11
		x11-libs/libXrender
		x11-libs/libXt
		|| ( >=x11-libs/libXtst-1.1.0 <x11-proto/xextproto-7.1 )
		x11-proto/inputproto
		virtual/pkgconfig
		${COMMON}"

RDEPEND=">=virtual/jre-1.4
	${COMMON}"

S="${WORKDIR}"

# JNI libraries don't need SONAME, bug #253756
QA_SONAME="usr/$(get_libdir)/libswt-.*.so"

src_unpack() {
	local DISTFILE=${A}
	unzip -jq "${DISTDIR}"/${DISTFILE} "*src.zip" || die "Unable to extract distfile"
	unpack "./src.zip"

	# Cleanup the redirtied directory structure
	rm -rf about_files/ || die
}

java_prepare() {
	# Replace the build.xml to allow compilation without Eclipse tasks
	cp "${FILESDIR}/build.xml" "${S}/build.xml" || die "Unable to update build.xml"
	mkdir "${S}/src" && mv "${S}/org" "${S}/src" || die "Unable to restructure SWT sources"

	# Fix Makefiles to respect flags and work with --as-needed
	epatch "${FILESDIR}"/as-needed-and-flag-fixes-3.6.patch
}

src_compile() {
	# Drop jikes support as it seems to be unfriendly with SWT
	java-pkg_filter-compiler jikes

	local AWT_ARCH
	local JAWTSO="libjawt.so"
	if [[ $(tc-arch) == 'x86' ]] ; then
		AWT_ARCH="i386"
	elif [[ $(tc-arch) == 'ppc' ]] ; then
		AWT_ARCH="ppc"
	elif [[ $(tc-arch) == 'ppc64' ]] ; then
		AWT_ARCH="ppc64"
	else
		AWT_ARCH="amd64"
	fi
	if [[ -f "${JAVA_HOME}/jre/lib/${AWT_ARCH}/${JAWTSO}" ]]; then
		export AWT_LIB_PATH="${JAVA_HOME}/jre/lib/${AWT_ARCH}"
	elif [[ -f "${JAVA_HOME}/jre/bin/${JAWTSO}" ]]; then
		export AWT_LIB_PATH="${JAVA_HOME}/jre/bin"
	elif [[ -f "${JAVA_HOME}/$(get_libdir)/${JAWTSO}" ]] ; then
		export AWT_LIB_PATH="${JAVA_HOME}/$(get_libdir)"
	else
		eerror "${JAWTSO} not found in the JDK being used for compilation!"
		die "cannot build AWT library"
	fi

	# Fix the pointer size for AMD64
	[[ ${ARCH} == "amd64" || ${ARCH} == "ppc64" ]] && export SWT_PTR_CFLAGS=-DJNI64

	local platform="linux"

	use elibc_FreeBSD && platform="freebsd"

	local make="emake -f make_${platform}.mak NO_STRIP=y CC=$(tc-getCC) CXX=$(tc-getCXX)"

	einfo "Building AWT library"
	${make} make_awt || die "Failed to build AWT support"

	einfo "Building SWT library"
	${make} make_swt || die "Failed to build SWT support"

	einfo "Building JAVA-AT-SPI bridge"
	${make} make_atk || die "Failed to build ATK support"

	if use gnome ; then
		einfo "Building GNOME VFS support"
		${make} make_gnome || die "Failed to build GNOME VFS support"
	fi

	if use cairo ; then
		einfo "Building CAIRO support"
		${make} make_cairo || die "Unable to build CAIRO support"
	fi

	if use opengl ; then
		einfo "Building OpenGL component"
		${make} make_glx || die "Unable to build OpenGL component"
	fi

	einfo "Building JNI libraries"
	eant compile

	einfo "Copying missing files"
	cp -i "${S}/version.txt" "${S}/build/version.txt"
	cp -i "${S}/src/org/eclipse/swt/internal/SWTMessages.properties" \
		"${S}/build/org/eclipse/swt/internal/"

	einfo "Packing JNI libraries"
	eant jar
}

src_install() {
	swtArch=${ARCH}
	use amd64 && swtArch=x86_64
	use x86-fbsd && swtArch=x86

	sed "s/SWT_ARCH/${swtArch}/" "${FILESDIR}/${PN}-${SLOT}-manifest" > "MANIFEST_TMP.MF"
	java-osgi_newjar-fromfile "swt.jar" "MANIFEST_TMP.MF" "Standard Widget Toolkit for GTK 2.0"

	java-pkg_sointo /usr/$(get_libdir)
	java-pkg_doso *.so

	dohtml about.html || die
}
