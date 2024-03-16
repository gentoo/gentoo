# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_p/+}"
SLOT="${MY_PV%%[.+]*}"
EGRADLE_VER="4.10.3"

inherit flag-o-matic java-pkg-2 multiprocessing toolchain-funcs

DESCRIPTION="Java OpenJFX client application platform"
HOMEPAGE="https://openjfx.io"

SRC_URI="
	https://hg.openjdk.java.net/${PN}/${SLOT}-dev/rt/archive/${MY_PV}.tar.bz2 -> ${P}.tar.bz2
	https://downloads.gradle.org/distributions/gradle-${EGRADLE_VER}-bin.zip
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-sandbox/7.1.0/lucene-sandbox-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-grouping/7.1.0/lucene-grouping-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-queryparser/7.1.0/lucene-queryparser-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-queries/7.1.0/lucene-queries-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-core/7.1.0/lucene-core-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/antlr/gunit/3.5.2/gunit-3.5.2.jar
	https://repo1.maven.org/maven2/org/antlr/antlr4/4.7.2/antlr4-4.7.2-complete.jar
	https://repo.maven.apache.org/maven2/org/antlr/ST4/4.0.8/ST4-4.0.8.jar
"

S="${WORKDIR}/rt-${MY_PV}"

LICENSE="GPL-2-with-classpath-exception"
KEYWORDS="-* ~amd64 ~ppc64"
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
	dev-java/antlr:0
	dev-java/antlr:3.5
	dev-java/hamcrest-core:0
	dev-java/stringtemplate:0
	virtual/ttf-fonts
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/11/disable-buildSrc-tests.patch
	"${FILESDIR}"/11/glibc-compatibility.patch
	"${FILESDIR}"/11/respect-user-cflags-11.0.11.patch
	"${FILESDIR}"/11/use-system-swt-jar.patch
	"${FILESDIR}"/11/wno-error-11.0.11.patch
	"${FILESDIR}"/11/don-t-force-msse-11.0.11.patch
	"${FILESDIR}"/11/disable-architecture-verification.patch
	"${FILESDIR}"/11/gstreamer-CVE-2021-3522.patch
	"${FILESDIR}"/11/ffmpeg5.patch
	"${FILESDIR}"/11/respect-cc.patch
	"${FILESDIR}"/11/strip-blank-elements-flags.patch
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
		#--debug
	)

	export GRADLE_HOME

	# FIXME: build.gradle believes $ANT_HOME/bin/ant shoud exist
	unset ANT_HOME

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
	unpack "${P}.tar.bz2"
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

	java-pkg_jar-from --build-only --with-dependencies --into "${d}" antlr
	java-pkg_jar-from --build-only --with-dependencies --into "${d}" antlr-3.5
	java-pkg_jar-from --build-only --with-dependencies --into "${d}" stringtemplate
	java-pkg_jar-from --build-only --with-dependencies --into "${d}" hamcrest-core

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
		rm -v build/sdk/lib/src.zip || die
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
