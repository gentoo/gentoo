# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_p/+}"
MY_PV2="${MY_PV%+*}"
SLOT="${MY_PV%%[.+]*}"

# https://docs.gradle.org/current/userguide/compatibility.html
EGRADLE_VER="8.5"

inherit flag-o-matic java-pkg-2 multiprocessing toolchain-funcs

DESCRIPTION="Java OpenJFX client application platform"
HOMEPAGE="https://openjfx.io"

SRC_URI="
	https://github.com/openjdk/jfx/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://downloads.gradle.org/distributions/gradle-${EGRADLE_VER}-bin.zip
	https://repo1.maven.org/maven2/org/antlr/antlr4/4.7.2/antlr4-4.7.2-complete.jar
"

S="${WORKDIR}/jfx-${MY_PV/+/-}"

LICENSE="GPL-2-with-classpath-exception"
KEYWORDS="-* ~amd64"
IUSE="cpu_flags_x86_sse2 debug doc source +media"
REQUIRED_USE="amd64? ( cpu_flags_x86_sse2 )"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-java/swt:4.10[cairo,opengl]
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-libs/libxslt
	media-libs/freetype:2
	media-libs/fontconfig:1.0
	media-libs/libjpeg-turbo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/cairo[glib]
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x11-libs/pango
	virtual/opengl
	doc? ( dev-java/openjdk:${SLOT}[doc] )
	!doc? (
		|| (
			dev-java/openjdk-bin:${SLOT}
			dev-java/openjdk:${SLOT}
		)
	)
"

DEPEND="${RDEPEND}
	app-arch/unzip
	app-arch/zip
	dev-java/ant:0
	dev-java/antlr:4
	dev-java/antlr:3.5
	dev-java/lucene:7.7.3
	dev-java/hamcrest-core:0
	dev-java/stringtemplate:0
	virtual/ttf-fonts
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${SLOT}/disable-buildSrc-tests.patch
	"${FILESDIR}"/${SLOT}/glibc-compatibility.patch
	"${FILESDIR}"/${SLOT}/respect-user-cflags-${MY_PV2}.patch
	"${FILESDIR}"/${SLOT}/use-system-swt-jar.patch
	"${FILESDIR}"/${SLOT}/wno-error-${MY_PV2}.patch
	"${FILESDIR}"/${SLOT}/don-t-force-msse-${MY_PV2}.patch
	"${FILESDIR}"/${SLOT}/disable-architecture-verification.patch
	"${FILESDIR}"/${SLOT}/ffmpeg5.patch
	"${FILESDIR}"/${SLOT}/respect-cc.patch
	"${FILESDIR}"/${SLOT}/strip-blank-elements-flags.patch

	# https://github.com/openjdk/jfx/pull/1256: fix build failure with gradle 8.5
	"${FILESDIR}"/${SLOT}/PR1256-14877233e1f15f400b84cccd79c0171a911298d8.patch
)

egradle() {
	local GRADLE_HOME="${WORKDIR}/gradle-${EGRADLE_VER}"
	local gradle="${GRADLE_HOME}/bin/gradle"
	local gradle_args=(
		--info
		--stacktrace
		--no-build-cache
		--no-daemon
		--offline
		--gradle-user-home "${T}/gradle_user_home"
		--project-cache-dir "${T}/gradle_project_cache"
		-F "off"
		#--debug
	)

	export GRADLE_HOME

	# FIXME: build.gradle believes $ANT_HOME/bin/ant shoud exist
	unset ANT_HOME

	# to avoid sandbox violations with dir creation in /var/lib/portage/home/.java
	export _JAVA_OPTIONS="-Duser.home=${HOME}"

	einfo "gradle "${gradle_args[@]}" ${@}"
	# TERM needed, otherwise gradle may fail on terms it does not know about
	TERM="xterm" "${gradle}" "${gradle_args[@]}" ${@} || die "gradle failed"
}

pkg_setup() {
	JAVA_PKG_WANT_BUILD_VM="openjdk-${SLOT} openjdk-bin-${SLOT}"
	JAVA_PKG_WANT_SOURCE="${SLOT}"
	JAVA_PKG_WANT_TARGET="${SLOT}"

	# The nastiness below is necessary while the gentoo-vm USE flag is
	# masked. First we call java-pkg-2_pkg_setup if it looks like the
	# flag was unmasked against one of the possible build VMs. If not,
	# we try finding one of them in their expected locations. This would
	# have been slightly less messy if openjdk-bin had been installed to
	# /opt/${PN}-${SLOT} or if there was a mechanism to install a VM env
	# file but disable it so that it would not normally be selectable.

	local vm
	for vm in ${JAVA_PKG_WANT_BUILD_VM}; do
		if [[ -d ${EPREFIX}/usr/lib/jvm/${vm} ]]; then
			java-pkg-2_pkg_setup
			return
		fi
	done

	if has_version -b dev-java/openjdk:${SLOT}; then
		export JAVA_HOME=${EPREFIX}/usr/$(get_libdir)/openjdk-${SLOT}
		export JDK_HOME="${JAVA_HOME}"
		export ANT_RESPECT_JAVA_HOME=true
	else
		if [[ ${MERGE_TYPE} != "binary" ]]; then
			JDK_HOME=$(best_version -b dev-java/openjdk-bin:${SLOT})
			[[ -n ${JDK_HOME} ]] || die "Build VM not found!"
			JDK_HOME=${JDK_HOME#*/}
			JDK_HOME=${EPREFIX}/opt/${JDK_HOME%-r*}
			export JDK_HOME
			export JAVA_HOME="${JDK_HOME}"
			export ANT_RESPECT_JAVA_HOME=true
		fi
	fi
}

src_unpack() {
	unpack "${P}.tar.gz"
	unpack "gradle-${EGRADLE_VER}-bin.zip"

	mkdir "${T}/jars" || die

	local line jar
	for line in ${SRC_URI}; do
		if [[ ${line} =~ (http|https)://[a-zA-Z0-9.-_]*/(maven2|m2|eclipse)/(.*[.]jar)$ ]]; then
			jar=$(basename "${BASH_REMATCH[-1]}")
			cp -v "${DISTDIR}/${jar}" "${T}/jars/" || die
		fi
	done
}

src_prepare() {
	default

	local d="${T}/jars"

	java-pkg_jar-from --build-only --with-dependencies --into "${d}" hamcrest-core
	java-pkg_jar-from --build-only --with-dependencies --into "${d}" lucene-7.7.3
	pushd "${d}"
	for lib in lucene*jar
	do
		mv ${lib} ${lib%.jar}-7.7.3.jar
	done
	popd

	# already included inside antlr4-complete.jar ...
	#java-pkg_jar-from --build-only --with-dependencies --into "${d}" antlr-4
	#java-pkg_jar-from --build-only --with-dependencies --into "${d}" stringtemplate-4
	sed -i "s#__gentoo_swt_jar__#$(java-pkg_getjars swt-4.10)#" "${S}"/build.gradle || die
}

src_configure() {
	append-flags -Wno-error -fcommon
	# This package is ridiculously brittle and fails when building e.g.
	# bundled gstreamer with LTO.
	filter-lto
	tc-export AR CC CXX

	# FIXME: still calls pkg-config etc by name without chost prefix
	# FIXME: should we enable webkit? doubt so

	# build is very sensitive to doc presence, take extra steps
	if use doc; then
		local jdk_doc
		if has_version -b dev-java/openjdk:${SLOT}[doc]; then
			jdk_doc="${EPREFIX}/usr/share/doc/openjdk-${SLOT}/html/api"
		fi
		[[ -r ${jdk_doc}/element-list ]] || die "JDK Docs not found, terminating build early"
	fi

	cat <<- _EOF_ > "${S}"/gradle.properties
		COMPILE_TARGETS = linux
		COMPILE_WEBKIT = false
		COMPILE_MEDIA = $(usex media true false)
		JDK_DOCS = https://docs.oracle.com/en/java/javase/${SLOT}/docs/api
		JDK_DOCS_LINK = $(usex doc "${jdk_doc}" "")
		BUILD_LIBAV_STUBS = false
		GRADLE_VERSION_CHECK = false
		LINT = none
		CONF = $(usex debug DebugNative Release)
		NUM_COMPILE_THREADS = $(makeopts_jobs)
		JFX_DEPS_URL = ${T}/jars
		COMPANY_NAME = "Gentoo"
	_EOF_
}

src_compile() {
	egradle zips $(usex doc "" "--exclude-task javadoc")
}

src_install() {
	if ! use source ; then
		rm -v build/sdk/src.zip || die
	fi

	insinto "/usr/$(get_libdir)/${PN}-${SLOT}"
	doins -r build/sdk/.
	doins build/javafx-exports.zip

	if use doc; then
		docinto html
		dodoc -r build/javadoc/.
		dosym ../../../usr/share/doc/"${PF}" /usr/share/doc/"${PN}-${SLOT}"
	fi
}
