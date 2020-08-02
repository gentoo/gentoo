# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils flag-o-matic java-pkg-2 java-ant-2 toolchain-funcs java-osgi

MY_PV="${PV/_rc/RC}"
MY_DMF="http://archive.eclipse.org/eclipse/downloads/drops4/R-${MY_PV}-201206081400"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="GTK based SWT Library"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="
	amd64? ( ${MY_DMF}/${MY_P}-gtk-linux-x86_64.zip )
	ppc? ( ${MY_DMF}/${MY_P}-gtk-linux-x86.zip )
	ppc64? ( ${MY_DMF}/${MY_P}-gtk-linux-ppc64.zip )
	x86? ( ${MY_DMF}/${MY_P}-gtk-linux-x86.zip )
	x86-fbsd? ( ${MY_DMF}/${MY_P}-gtk-linux-x86.zip )"

LICENSE="CPL-1.0 LGPL-2.1 MPL-1.1"
SLOT="4.2"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="cairo opengl"

COMMON_DEPEND="
	>=dev-libs/atk-1.10.2
	>=dev-libs/glib-2.32
	>=x11-libs/gtk+-2.6.8:2
	x11-libs/libXtst
	cairo? ( >=x11-libs/cairo-1.4.14 )
	opengl?	(
		virtual/glu
		virtual/opengl
	)"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	virtual/jdk:1.8
	virtual/pkgconfig
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXt
	>=x11-libs/libXtst-1.1.0"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.4"

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
	epatch "${FILESDIR}"/${P}-as-needed-and-flag-fixes.patch

	# Define missing g_thread_supported() to be 0.
	sed -i '1s/^/#define g_thread_supported() 0\n\n/' "${S}"/os_custom.h || die
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

	# Bug #461784, g_thread_init is deprecated since glib-2.32.
	append-cflags -DNO__1g_1thread_1init

	local make="emake -f make_${platform}.mak NO_STRIP=y CC=$(tc-getCC) CXX=$(tc-getCXX)"

	einfo "Building AWT library"
	${make} make_awt

	einfo "Building SWT library"
	${make} make_swt

	einfo "Building JAVA-AT-SPI bridge"
	${make} make_atk

	if use cairo ; then
		einfo "Building CAIRO support"
		${make} make_cairo
	fi

	if use opengl ; then
		einfo "Building OpenGL component"
		${make} make_glx
	fi

	einfo "Building JNI libraries"
	eant compile

	einfo "Copying missing files"
	cp -i "${S}/version.txt" "${S}/build/version.txt"
	cp -i "${S}/src/org/eclipse/swt/internal/SWTMessages.properties" \
		"${S}/build/org/eclipse/swt/internal/" || die

	einfo "Packing JNI libraries"
	eant jar
}

src_install() {
	swtArch=${ARCH}
	use amd64 && swtArch=x86_64
	use x86-fbsd && swtArch=x86

	sed "s/SWT_ARCH/${swtArch}/" "${FILESDIR}/${PN}-${SLOT}-manifest" > "MANIFEST_TMP.MF" || die
	use cairo || sed -i -e "/ org.eclipse.swt.internal.cairo; x-internal:=true,/d" "MANIFEST_TMP.MF"
	sed -i -e "/ org.eclipse.swt.internal.gnome; x-internal:=true,/d" "MANIFEST_TMP.MF"
	use opengl || sed -i -e "/ org.eclipse.swt.internal.opengl.glx; x-internal:=true,/d" "MANIFEST_TMP.MF"
	sed -i -e "/ org.eclipse.swt.internal.webkit; x-internal:=true,/d" "MANIFEST_TMP.MF"
	java-osgi_newjar-fromfile "swt.jar" "MANIFEST_TMP.MF" "Standard Widget Toolkit for GTK 2.0"

	java-pkg_sointo /usr/$(get_libdir)
	java-pkg_doso *.so

	dohtml about.html
}
