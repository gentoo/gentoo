# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit flag-o-matic java-pkg-2 java-pkg-simple multiprocessing toolchain-funcs

EGRADLE_VER="4.10.3"
EHG_COMMIT="9f49e3b6147f"

DESCRIPTION="Java OpenJFX 8 client application platform"
HOMEPAGE="https://openjfx.io"
SRC_URI="
	https://hg.openjdk.java.net/${PN}/8u-dev/rt/archive/${EHG_COMMIT}.tar.bz2 -> ${P}.tar.bz2
	https://dev.gentoo.org/~gyakovlev/distfiles/${P}-backports.tar.bz2
	https://downloads.gradle.org/distributions/gradle-${EGRADLE_VER}-bin.zip
"
# eclass overrides it, set back to normal
S="${WORKDIR}/${P}"

LICENSE="GPL-2-with-classpath-exception"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc64"
IUSE="debug doc media cpu_flags_x86_sse2"
REQUIRED_USE="amd64? ( cpu_flags_x86_sse2 )"
RESTRICT="test" # needs junit version we don't have, fragile

DEPEND="
	app-arch/unzip
	>=dev-java/ant-1.10.14:0
	>=dev-java/antlr-2.7.7-r7:0
	dev-java/antlr:3
	dev-java/openjdk:8
	dev-java/stringtemplate:0
	dev-java/swt:4.10[cairo,opengl]
	app-alternatives/yacc
	app-alternatives/lex
	virtual/jdk:1.8
	virtual/pkgconfig
"

RDEPEND="
	dev-java/swt:4.10[cairo,opengl]
	virtual/jre:1.8
"

# FIXME: majority of flags are honored, needs a bit more patching
QA_FLAGS_IGNORED=".*"

JAVA_PKG_WANT_BUILD_VM="openjdk-8"
JAVA_PKG_WANT_SOURCE="1.8"
JAVA_PKG_WANT_TARGET="1.8"

PATCHES=(
	"${FILESDIR}"/8/99-sysdeps.patch
	"${FILESDIR}"/8/disable-online-repos.patch
	"${FILESDIR}"/8/respect_flags.patch
	"${FILESDIR}"/8/0000-Fix-wait-call-in-PosixPlatform.patch
	"${FILESDIR}"/8/0001-Change-Lucene.patch
	"${FILESDIR}"/8/0003-fix-cast-between-incompatible-function-types.patch
	"${FILESDIR}"/8/0004-Fix-Compilation-Flags.patch
	"${FILESDIR}"/8/0005-don-t-include-xlocale.h.patch
	"${FILESDIR}"/8/06-disable-architecture-verification.patch
	"${FILESDIR}"/8/10-javadoc-locale.patch
	"${FILESDIR}"/8/Wno-error.patch
	"${FILESDIR}"/8/don-t-force-msse.patch
	"${FILESDIR}"/8/fxpackager-don-t-include-obsolete-sys-sysctl.h.patch
	"${FILESDIR}"/8/missing-casts.patch
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
		--gradle-user-home	"${T}/gradle_user_home"
		--project-cache-dir "${T}/gradle_project_cache"
	)

	export GRADLE_HOME

	# FIXME: build.gradle believes $ANT_HOME/bin/ant shoud exist
	unset ANT_HOME

	einfo "gradle "${gradle_args[@]}" ${@}"
	# TERM needed, otherwise gradle may fail on terms it does not know about
	TERM="xterm" "${gradle}" "${gradle_args[@]}" ${@} || die "gradle failed"
}

src_unpack() {
	default
	mv -v "rt-${EHG_COMMIT}" "${P}" || die
}

src_prepare() {
	eapply "${WORKDIR}/${P}-backports"
	default

	# this will create local jar storage to be used as ivy repo
	local d="${T}/jars"
	mkdir "${d}" || die

	# we need jars subdir in every prokect so gradle can find them
	# only system jars, no bundling
	local target targets
	targets=(
		jars
		buildSrc/jars
		modules/{base,builders,controls,extensions,fxml}/jars
		modules/{graphics,jmx,media,swing,swt,web,fxpackager}/jars
	)
	einfo "Copying system jars"
	for target in ${targets[@]}; do
		ln -vs "${T}/jars" "${target}" || die
	done

	local swt_file_name="$(java-pkg_getjars swt-4.10)"
	java-pkg_jar-from --build-only --into "${d}" ant ant.jar ant-1.8.2.jar
	java-pkg_jar-from --build-only --into "${d}" ant ant-launcher.jar ant-launcher-1.8.2.jar
	java-pkg_jar-from --build-only --into "${d}" antlr antlr.jar antlr-2.7.7.jar
	java-pkg_jar-from --build-only --into "${d}" antlr-3 antlr-tool.jar antlr-3.1.3.jar
	java-pkg_jar-from --build-only --into "${d}" antlr-3 antlr-runtime.jar antlr-runtime-3.1.3.jar
	java-pkg_jar-from --build-only --into "${d}" stringtemplate  stringtemplate.jar stringtemplate-3.2.jar
	sed -i "s#compile name: SWT_FILE_NAME#compile files(\"${swt_file_name}\")#" "${S}"/build.gradle || die

	sed -i 's/-rpath/-rpath-link/g' modules/media/src/main/native/jfxmedia/projects/linux/Makefile || die
}

src_configure() {
	# see gradle.properties.template in ${S}
	cat <<- _EOF_ > "${S}"/gradle.properties
		COMPILE_TARGETS = linux
		GRADLE_VERSION_CHECK = false
		COMPILE_AVPLUGIN = $(usex media true false)
		COMPILE_MEDIA = $(usex media true false)
		COMPILE_WEBKIT = false
		BUILD_JAVADOC = $(usex doc true false)
		BUILD_SRC_ZIP = $(usex source true false)
		FULL_TEST = false
		CONF = $(usex debug DebugNative Release)
		NUM_COMPILE_THREADS = $(makeopts_jobs)
	_EOF_

	local repostring='
		repositories {
		ivy {
			url file("${projectDir}/jars")
			layout "pattern", {
				artifact "[artifact]-[revision].[ext]"
				artifact "[artifact].[ext]"
			}
		}
		mavenLocal()
	}'

	cat <<- _EOF_ > "${S}"/buildSrc/gentoo.gradle
		${repostring}
	_EOF_

	cat <<- _EOF_ > "${S}"/gentoo.gradle
		${repostring}
		allprojects {
			${repostring}
		}
	_EOF_

	echo "apply from: 'gentoo.gradle'" >> build.gradle || die
	echo "apply from: 'gentoo.gradle'" >> buildSrc/build.gradle || die
	sed -i 's/mavenCentral/mavenLocal/g' build.gradle || die
	sed -i 's/mavenCentral/mavenLocal/g' buildSrc/build.gradle || die
	einfo "Configured with the following settings:"
	cat gradle.properties || die

}

src_compile() {
	append-cflags '-fcommon'
	tc-export_build_env CC CXX PKG_CONFIG
	rm -r tests buildSrc/src/test || die
	egradle openExportLinux
}

src_install() {
	local dest="/usr/$(get_libdir)/openjdk-${SLOT}"
	local ddest="${ED}${dest}"
	dodir "${dest}"
	pushd build/export/sdk > /dev/null || die
	cp -pPRv * "${ddest}" || die
	popd > /dev/null || die
}
