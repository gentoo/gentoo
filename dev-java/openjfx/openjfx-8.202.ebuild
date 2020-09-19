# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple multiprocessing toolchain-funcs

MY_PV="$(ver_rs 1 'u' 2 '-' ${PV//p/b})-ga"
EGRADLE_VER="4.8"

DESCRIPTION="Java OpenJFX 8 client application platform"
HOMEPAGE="https://openjfx.io"
SRC_URI="
	http://hg.openjdk.java.net/${PN}/8u/rt/archive/${MY_PV}.tar.bz2 -> ${P}.tar.bz2
	https://services.gradle.org/distributions/gradle-${EGRADLE_VER}-bin.zip
"

LICENSE="GPL-2-with-classpath-exception"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc64"

IUSE="debug doc media cpu_flags_x86_sse2"

DEPEND="
	app-arch/unzip
	>=dev-java/ant-core-1.8.2:0
	>=dev-java/antlr-2.7.7-r7:0
	dev-java/antlr:3
	dev-java/stringtemplate:0
	dev-java/swt:4.10[cairo,opengl]
	sys-devel/bison
	sys-devel/flex
	virtual/jdk:1.8
	virtual/pkgconfig
"

RDEPEND="
	dev-java/swt:4.10[cairo,opengl]
	virtual/jre:1.8
"

REQUIRED_USE="amd64? ( cpu_flags_x86_sse2 )"

RESTRICT="test" # needs junit version we don't have, fragile

# FIXME: majority of flags are honored, needs a bit more patching
QA_FLAGS_IGNORED="*"

S="${WORKDIR}/rt-${MY_PV}"

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
	"${FILESDIR}"/8/07-disable-assembler-on-unsupported-archs.patch
	"${FILESDIR}"/8/10-javadoc-locale.patch
	"${FILESDIR}"/8/Wno-error.patch
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

src_prepare() {
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
	java-pkg_jar-from --build-only --into "${d}" ant-core ant.jar ant-1.8.2.jar
	java-pkg_jar-from --build-only --into "${d}" ant-core ant-launcher.jar ant-launcher-1.8.2.jar
	java-pkg_jar-from --build-only --into "${d}" antlr antlr.jar antlr-2.7.7.jar
	java-pkg_jar-from --build-only --into "${d}" antlr-3 antlr-tool.jar antlr-3.1.3.jar
	java-pkg_jar-from --build-only --into "${d}" antlr-3 antlr-runtime.jar antlr-runtime-3.1.3.jar
	java-pkg_jar-from --build-only --into "${d}" stringtemplate  stringtemplate.jar stringtemplate-3.2.jar
	sed -i "s#compile name: SWT_FILE_NAME#compile files(\"${swt_file_name#/}\")#" "${S}"/build.gradle || die

	sed -i 's/-rpath/-rpath-link/g' modules/media/src/main/native/jfxmedia/projects/linux/Makefile || die
}

src_configure() {
	# see gradle.properties.template in ${S}
	cat <<- _EOF_ > "${S}"/gradle.properties
		COMPILE_TARGETS = linux
		GRADLE_VERSION_CHECK = false
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

}

src_compile() {
	tc-export_build_env CC CXX PKG_CONFIG
	rm -r tests buildSrc/src/test || die
	egradle openExportLinux
}

src_install() {
	local dest="/usr/$(get_libdir)/openjdk-${SLOT}"
	local ddest="${ED%/}/${dest#/}"
	dodir "${dest}"
	pushd build/export/sdk > /dev/null || die
	cp -pPRv * "${ddest}" || die
	popd > /dev/null || die
}
