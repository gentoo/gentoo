# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic java-pkg-2 java-ant-2 toolchain-funcs java-osgi

MY_PV="${PV/_rc/RC}"
MY_DMF="http://download.eclipse.org/eclipse/downloads/drops4/R-${MY_PV}-201812060815"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="GTK based SWT Library"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="
	amd64? ( ${MY_DMF}/${MY_P}-gtk-linux-x86_64.zip )
	ppc64? ( ${MY_DMF}/${MY_P}-gtk-linux-ppc64le.zip )"

LICENSE="CPL-1.0 LGPL-2.1 MPL-1.1"
SLOT="4.10"
KEYWORDS="~amd64 ~ppc64"
IUSE="cairo opengl webkit"

COMMON_DEP="
	>=dev-libs/atk-1.10.2
	>=dev-libs/glib-2.32
	>=x11-libs/gtk+-2.6.8:2
	x11-libs/libXtst
	cairo? ( >=x11-libs/cairo-1.4.14 )
	opengl?	(
		virtual/glu
		virtual/opengl
	)
	webkit? (
		net-libs/webkit-gtk:4
	)"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.8
	app-arch/unzip
	virtual/pkgconfig
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXt
	>=x11-libs/libXtst-1.1.0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.8"

S="${WORKDIR}"

# JNI libraries don't need SONAME, bug #253756
QA_SONAME='usr/lib[^/]*/libswt-[^/]+.so'

PATCHES=(
	"${FILESDIR}"/${P}-as-needed-and-flag-fixes.patch
)

src_unpack() {
	local DISTFILE=${A}
	unzip -jq "${DISTDIR}"/${DISTFILE} swt.jar src.zip || die "Unable to extract distfile"
	unpack "./src.zip"

	# Cleanup the redirtied directory structure
	rm -rf about_files/ || die
}

src_prepare() {
	# Replace the build.xml to allow compilation without Eclipse tasks
	cp "${FILESDIR}/build.xml" "${S}/build.xml" || die "Unable to update build.xml"
	mkdir "${S}/src" && mv "${S}/org" "${S}/src" || die "Unable to restructure SWT sources"

	# Apply patches
	default

	# Define missing g_thread_supported() to be already started.
	sed -i '1s/^/#define g_thread_supported() 1\n\n/' "${S}"/os_custom.h || die

	# Webext is also in the library directory
	sed -i 's|findResource([^,]\+|findResource("swt"|' \
		"${S}"/src/org/eclipse/swt/browser/WebKit.java || die
}

src_compile() {
	append-cflags -fcommon # https://bugs.gentoo.org/707838

	# Drop jikes support as it seems to be unfriendly with SWT
	java-pkg_filter-compiler jikes

	local AWT_ARCH
	local JAWTSO="libjawt.so"
	if [[ $(tc-arch) == 'ppc64' ]] ; then
		# no big-endian support
		AWT_ARCH="ppc64le"
	else
		AWT_ARCH="amd64"
	fi
	if [[ -f "${JAVA_HOME}/jre/lib/${AWT_ARCH}/${JAWTSO}" ]]; then
		export AWT_LIB_PATH="${JAVA_HOME}/jre/lib/${AWT_ARCH}"
	elif [[ -f "${JAVA_HOME}/jre/bin/${JAWTSO}" ]]; then
		export AWT_LIB_PATH="${JAVA_HOME}/jre/bin"
	elif [[ -f "${JAVA_HOME}/$(get_libdir)/${JAWTSO}" ]] ; then
		export AWT_LIB_PATH="${JAVA_HOME}/$(get_libdir)"
	elif [[ -f "${JAVA_HOME}/lib/${JAWTSO}" ]] ; then
		export AWT_LIB_PATH="${JAVA_HOME}/lib"
	else
		eerror "${JAWTSO} not found in the JDK being used for compilation!"
		die "cannot build AWT library"
	fi

	# Fix the pointer size for AMD64
	export SWT_PTR_CFLAGS=-DJNI64

	# Bug #461784, g_thread_init is deprecated since glib-2.32.
	append-cflags -DNO__1g_1thread_1init

	local make="emake -f make_linux.mak NO_STRIP=y CC=$(tc-getCC) CXX=$(tc-getCXX)"

	einfo "Building AWT library"
	${make} make_awt AWT_LIBS="-L\$(AWT_LIB_PATH) -Wl,-rpath,\$(AWT_LIB_PATH) -ljawt \`pkg-config --libs x11\`"

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

	if use webkit ; then
		einfo "Building WebKit component"
		${make} make_webkit make_webkit2extension
	fi

	einfo "Building JNI libraries"
	eant compile

	einfo "Copying missing files"
	cp -i "${S}/version.txt" "${S}/build/version.txt" || die
	cp -i "${S}/src/org/eclipse/swt/internal/SWTMessages.properties" \
		"${S}/build/org/eclipse/swt/internal/" || die
	unzip swt.jar 'org/eclipse/swt/internal/gtk/*.css' -d build || die

	einfo "Packing JNI libraries"
	eant jar
}

src_install() {
	local swtArch=${ARCH}
	use amd64 && swtArch=x86_64

	sed "s/SWT_ARCH/${swtArch}/" "${FILESDIR}/${PN}-${SLOT}-manifest" > "MANIFEST_TMP.MF" || die
	remove_from_manifest() {
		local subpkg=$1
		sed -i -e "/ org.eclipse.swt.internal.$subpkg; x-internal:=true,/d" "MANIFEST_TMP.MF" || die
	}
	use cairo || remove_from_manifest cairo
	use opengl || remove_from_manifest opengl.glx
	use webkit || remove_from_manifest webkit
	java-osgi_newjar-fromfile "swt.jar" "MANIFEST_TMP.MF" "Standard Widget Toolkit for GTK 2.0"

	java-pkg_sointo "/usr/$(get_libdir)/swt"
	java-pkg_doso *.so

	dodoc about.html
}
