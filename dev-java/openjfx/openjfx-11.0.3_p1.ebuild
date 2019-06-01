# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV=${PV/_p/+}
SLOT=${MY_PV%%[.+]*}
EGRADLE_VER="4.8"

inherit java-pkg-2 multiprocessing

DESCRIPTION="Java OpenJFX client application platform"
HOMEPAGE="https://openjfx.io"

SRC_URI="https://hg.openjdk.java.net/${PN}/${SLOT}/rt/archive/${MY_PV}.tar.bz2 -> ${P}.tar.bz2
	https://downloads.gradle.org/distributions/gradle-${EGRADLE_VER}-bin.zip
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-sandbox/7.1.0/lucene-sandbox-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-grouping/7.1.0/lucene-grouping-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-queryparser/7.1.0/lucene-queryparser-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-queries/7.1.0/lucene-queries-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/apache/lucene/lucene-core/7.1.0/lucene-core-7.1.0.jar
	https://repo.maven.apache.org/maven2/org/antlr/gunit/3.5.2/gunit-3.5.2.jar
	https://repo.maven.apache.org/maven2/org/antlr/antlr-complete/3.5.2/antlr-complete-3.5.2.jar
	https://repo.maven.apache.org/maven2/org/antlr/ST4/4.0.8/ST4-4.0.8.jar
"

LICENSE="GPL-2-with-classpath-exception"
SLOT="$(ver_cut 1)"
KEYWORDS="-* ~amd64"

IUSE="cpu_flags_x86_sse2 debug doc source +media"

RDEPEND="
	dev-java/swt:4.10[cairo,opengl]
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-libs/libxslt
	media-libs/freetype:2
	media-libs/fontconfig:1.0
	media-video/ffmpeg:0=
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/cairo[glib]
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x11-libs/pango
	virtual/jpeg
	virtual/opengl
	|| (
		dev-java/openjdk-bin:${SLOT}[doc?]
		dev-java/openjdk:${SLOT}[doc?]
	)
"

DEPEND="${RDEPEND}
	app-arch/unzip
	app-arch/zip
	>=dev-java/ant-core-1.10.5-r2:0
	dev-java/antlr:0
	dev-java/antlr:3.5
	dev-java/hamcrest-core:0
	dev-java/stringtemplate:0
	virtual/ttf-fonts
	virtual/pkgconfig
"

REQUIRED_USE="cpu_flags_x86_sse2"

PATCHES=(
	"${FILESDIR}"/11/disable-buildSrc-tests.patch
	"${FILESDIR}"/11/glibc-compatibility.patch
	"${FILESDIR}"/11/respect-user-cflags.patch
	"${FILESDIR}"/11/use-system-swt-jar.patch
	"${FILESDIR}"/11/fix-build-on-gradle-5x.patch
)

S="${WORKDIR}/rt-${MY_PV}"

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
	)

	export GRADLE_HOME

	# FIXME: build.gradle believes $ANT_HOME/bin/ant shoud exist
	unset ANT_HOME

	einfo "gradle "${gradle_args[@]}" ${@}"
	"${gradle}" "${gradle_args[@]}" ${@} || die "gradle failed"
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

	if has_version --host-root dev-java/openjdk:${SLOT}; then
		export JAVA_HOME=${EPREFIX}/usr/$(get_libdir)/openjdk-${SLOT}
		export JDK_HOME="${JAVA_HOME}"
		export ANT_RESPECT_JAVA_HOME=ture

	else
		if [[ ${MERGE_TYPE} != "binary" ]]; then
			JDK_HOME=$(best_version --host-root dev-java/openjdk-bin:${SLOT})
			[[ -n ${JDK_HOME} ]] || die "Build VM not found!"
			JDK_HOME=${JDK_HOME#*/}
			JDK_HOME=${EPREFIX}/opt/${JDK_HOME%-r*}
			export JDK_HOME
			export JAVA_HOME="${JDK_HOME}"
			export ANT_RESPECT_JAVA_HOME=ture
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
	#FIXME: still calls gcc, pkg-config etc by name without chost prefix
	#FIXME: should we enable webkit? doubt so

	# build is very sensetive to doc presense, take extra steps
	if use doc; then
		local jdk_doc
		if has_version --host-root dev-java/openjdk:${SLOT}[doc]; then
			jdk_doc="${EROOT%/}/usr/share/doc/openjdk-${SLOT}/html/api"
		elif has_version --host-root dev-java/java-sdk-docs:${SLOT}; then
			jdk_doc="${EROOT%/}/usr/share/doc/java-sdk-docs-${SLOT}/html/api"
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
		insinto /usr/share/doc/"${PF}"/html
		doins -r build/javadoc/.
		dosym /usr/share/doc/"${PF}" /usr/share/doc/"${PN}-${SLOT}"
	fi
}
