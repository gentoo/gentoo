# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit flag-o-matic java-pkg-2 java-pkg-simple toolchain-funcs java-osgi

MY_PV="${PV/_rc/RC}"
MY_DMF="https://archive.eclipse.org/eclipse/downloads/drops4/R-${MY_PV}-201812060815"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="GTK based SWT Library"
HOMEPAGE="https://www.eclipse.org/swt/"
SRC_URI="
	amd64? ( ${MY_DMF}/${MY_P}-gtk-linux-x86_64.zip )
	ppc64? ( ${MY_DMF}/${MY_P}-gtk-linux-ppc64le.zip )"

LICENSE="CPL-1.0 LGPL-2.1 MPL-1.1"
SLOT="4.10"
KEYWORDS="amd64 ppc64"
IUSE="cairo opengl webkit"

BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"
COMMON_DEP="
	app-accessibility/at-spi2-core:2
	dev-libs/glib
	>=x11-libs/gtk+-2.6.8:2
	x11-libs/libXtst
	cairo? ( x11-libs/cairo )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	webkit? (
		net-libs/webkit-gtk:4
	)"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.8:*[-headless-awt]
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXtst"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.8:*
	x11-libs/libX11"

# JNI libraries don't need SONAME, bug #253756
QA_SONAME='usr/lib[^/]*/libswt-[^/]+.so'

JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="src"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed-and-flag-fixes.patch
)

src_unpack() {
	default
	unpack "./src.zip"
}

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	# .css stuff is essential at least for running net-p2p/biglybt
	unzip swt.jar 'org/eclipse/swt/internal/gtk/*.css' -d resources || die
	java-pkg_clean

	# Define missing g_thread_supported() to be already started.
	sed -i '1s/^/#define g_thread_supported() 1\n\n/' "${S}"/os_custom.h || die

	# Webext is also in the library directory
	sed -i 's|findResource([^,]\+|findResource("swt"|' \
		org/eclipse/swt/browser/WebKit.java || die

	mkdir src || die "mkdir failed"
	mv org src || die "moving java sources failed"
	pushd src > /dev/null || die
		find -type f ! -name '*.java' \
			| xargs \
			cp --parent -t ../resources -v \
			|| die "copying resources failed"
	popd > /dev/null || die
	cp version.txt resources || die "adding version.txt failed"
}

src_compile() {
	append-cflags -fcommon # https://bugs.gentoo.org/707838

	local JAWTSO="libjawt.so"
	IFS=":" read -r -a ldpaths <<< $(java-config -g LDPATH)

	for libpath in "${ldpaths[@]}"; do
		if [[ -f "${libpath}/${JAWTSO}" ]]; then
			export AWT_LIB_PATH="${libpath}"
			break
		# this is a workaround for broken LDPATH in <=openjdk-8.292_p10 and <=dev-java/openjdk-bin-8.292_p10
		elif [[ -f "${libpath}/$(tc-arch)/${JAWTSO}" ]]; then
			export AWT_LIB_PATH="${libpath}/$(tc-arch)"
			break
		fi
	done

	if [[ -z "${AWT_LIB_PATH}" ]]; then
		eerror "${JAWTSO} not found in the JDK being used for compilation!"
		die "cannot build AWT library"
	fi

	# Fix the pointer size for AMD64
	export SWT_PTR_CFLAGS=-DJNI64

	# Bug #461784, g_thread_init is deprecated since glib-2.32.
	append-cflags -DNO__1g_1thread_1init

	local make="emake -f make_linux.mak NO_STRIP=y CC=$(tc-getCC) CXX=$(tc-getCXX)"

	einfo "Building AWT library"
	export SWT_JAVA_HOME="$(java-config -g JAVA_HOME)"
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
		${make} make_webkit
	fi

	java-pkg-simple_src_compile
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
