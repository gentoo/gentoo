# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

JAVA_PKG_IUSE="doc source"

inherit eutils check-reqs java-pkg-2 versionator

SV="$(get_version_component_range 1-2)"

# Note: to bump scala, some things to try are:
# 1. update all the sha1s in JURI
# 2. remove the https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.gz
# and https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.gz from
# SRC_URI
# 3. try emerge scala.  Check if it downloads more stuff in src_compile to
# ${WORKDIR}/.ivy2 or ${WORKDIR}/.sbt or /root/.ivy2 or /root/.sbt
# 4. tar up all the .ivy2 and .sbt junk into ${P}-ivy2-deps.tar.xz and
# ${P}-sbt-deps.tar.xz and add them to SRC_URI:
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-ivy2-deps.tar.xz .ivy2/cache
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-sbt-deps.tar.xz .sbt

# creating the binary:
# FEATURES="noclean -test" USE="doc source" emerge dev-lang/scala
# cd $WORDKIR
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-gentoo-binary.tar.xz .ivy2/local \
# ${P}/build/pack/bin ${P}/build/quick/classes/scala-dist/man/man1 \
# ${P}/src/library ${P}/src/library-aux ${P}/src/reflect ${P}/doc/README \
# ${P}/build/scaladoc

# In the pullJarFiles function in tools/binary-repo-lib.sh it executes find commands
# to search for .desired.sha1 files, which contain sha1 hashes that are appended
# to ${BURI} along with the subdirectory and filename to form the list of jar files
# listed in SRC_URI.  The output of this find command can be hacked into the desired format:
# find . -name \*.desired.sha1 -exec sed -e 's@\([0-9a-f]*\).*@\1@' {} \; -print
# After editing it into the desired format: sort -t / -k 3 file

BURI="http://repo.typesafe.com/typesafe/scala-sha-bootstrap/org/scala-lang/bootstrap"

declare -a JURI=(
	"${BURI}/943cd5c8802b2a3a64a010efb86ec19bac142e40/lib/ant/ant-contrib.jar -> ${P}-ant-contrib.jar"
	"${BURI}/3fc1e35ca8c991fc3488548f7a276bd9053c179d/lib/ant/ant-dotnet-1.0.jar -> ${P}-ant-dotnet-1.0.jar"
	"${BURI}/7b456ca6b93900f96e58cc8371f03d90a9c1c8d1/lib/ant/ant.jar -> ${P}-ant.jar"
	"${BURI}/7e50e3e227d834695f1e0bf018a7326e06ee4c86/lib/ant/maven-ant-tasks-2.1.1.jar -> ${P}-maven-ant-tasks-2.1.1.jar"
	"${BURI}/2c61d6e9a912b3253194d5d6d3e1db7e2545ac4b/lib/ant/vizant.jar -> ${P}-vizant.jar"
	"${BURI}/e737b123d31eede5594ceda07caafed1673ec472/test/files/codelib/code.jar -> ${P}-code.jar"
	"${BURI}/02fe2ed93766323a13f22c7a7e2ecdcd84259b6c/test/files/lib/annotations.jar -> ${P}-annotations.jar"
	"${BURI}/981392dbd1f727b152cd1c908c5fce60ad9d07f7/test/files/lib/enums.jar -> ${P}-enums.jar"
	"${BURI}/b1ec8a095cec4902b3609d74d274c04365c59c04/test/files/lib/genericNest.jar -> ${P}-genericNest.jar"
	"${BURI}/346d3dff4088839d6b4d163efa2892124039d216/test/files/lib/jsoup-1.3.1.jar -> ${P}-jsoup-1.3.1.jar"
	"${BURI}/3794ec22d9b27f2b179bd34e9b46db771b934ec3/test/files/lib/macro210.jar -> ${P}-macro210.jar"
	"${BURI}/be8454d5e7751b063ade201c225dcedefd252775/test/files/lib/methvsfield.jar -> ${P}-methvsfield.jar"
	"${BURI}/cd33e0a0ea249eb42363a2f8ba531186345ff68c/test/files/lib/nest.jar -> ${P}-nest.jar"
	"${BURI}/1b11ac773055c1e942c6b5eb4aabdf02292a7194/test/files/speclib/instrumented.jar -> ${P}-instrumented.jar"
)

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="http://www.scala-lang.org/"
SRC_URI="
	!binary?  (
		https://github.com/scala/scala/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.xz
		https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.xz
		${JURI[@]} )
	binary? (
		https://dev.gentoo.org/~gienah/files/dist/${P}-gentoo-binary.tar.xz )"
LICENSE="BSD"
SLOT="${SV}/${PV}"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"

IUSE="binary emacs"

COMMON_DEP="dev-java/ant-core:0
	dev-java/jline:2"

DEPEND="${COMMON_DEP}
	!binary? (
		=virtual/jdk-1.8*
		>=dev-java/sbt-0.13.13
		media-gfx/graphviz
	)
	binary? (
		>=virtual/jdk-1.8
	)
	app-arch/xz-utils:0"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.8
	app-eselect/eselect-scala
	!dev-lang/scala-bin:0"

PDEPEND="emacs? ( app-emacs/scala-mode:0 )"

CHECKREQS_MEMORY="1536M"

pkg_setup() {
	java-pkg-2_pkg_setup

	if ! use binary; then
		debug-print "Checking for sufficient physical RAM"

		ewarn "This package can fail to build with memory allocation errors in some cases."
		ewarn "If you are unable to build from sources, please try USE=binary"
		ewarn "for this package. See bug #181390 for more information."

		check-reqs_pkg_setup
	fi
}

src_unpack() {
	# Unpack tar files only.
	for f in ${A} ; do
		[[ ${f} == *".tar."* ]] && unpack ${f}
	done
}

src_prepare() {
	java-pkg_getjars ant-core,jline-2

	if ! use binary; then
		local a
		for a in "${JURI[@]}"
		do
			echo "${a}"
			local g="${a/* -> /}"
			echo "${g}"
			local j="${a/ -> */}"
			echo "${j}"
			cp -p "${DISTDIR}/${g}" "${S}/${j#${BURI}/*/}" || die
		done

		# gentoo patch (by gienah) to stop it calling git log in the build
		eapply "${FILESDIR}/${PN}-2.12.4-no-git.patch"

		local SBT_PVR="$(java-config --query=PVR --package=sbt)"
		sed -e "s@sbt.version=0.13.11@sbt.version=${SBT_PVR}@" \
			-i "${S}/project/build.properties" \
			|| die "Could not set sbt.version=${SBT_PVR} in project/build.properties"

		cat <<- EOF > "${S}/sbt"
			#!/bin/bash
			gjl_package=sbt
			gjl_jar="sbt-launch.jar"
			gjl_java_args="-Dsbt.version=0.13.13 -Dfile.encoding=UTF8 -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -Duser.home="${WORKDIR}""
			source /usr/share/java-config-2/launcher/launcher.bash
		EOF
		chmod u+x "${S}/sbt" || die

		sed -e 's@-Xmx1024M@-Xmx1536M@' \
			-i "${S}/build.sbt" \
			|| die "Could not change increase memory size in ${S}/build.sbt"
	fi

	default
}

src_compile() {
	if ! use binary; then
		export PATH="${EROOT}usr/share/scala-${SV}/bin:${WORKDIR}/${L_P}:${PATH}"
		einfo "=== scala compile ..."
		"${S}"/sbt -Dsbt.log.noformat=true compile || die "sbt compile failed"
		einfo "=== sbt publishLocal with jdk $(java-pkg_get-vm-version) ..."
		"${S}"/sbt -Dsbt.log.noformat=true publishLocal \
			|| die "sbt publishLocal failed"
	else
		einfo "Skipping compilation, USE=binary is set."
	fi
}

src_test() {
	if ! use binary; then
		"${S}"/sbt -Dsbt.log.noformat=true test || die "sbt test failed"
	else
		einfo "Skipping tests, USE=binary is set."
	fi
}

src_install() {
	pushd build/pack || die
	local SCALADIR="/usr/share/${PN}-${SV}"
	exeinto "${SCALADIR}/bin"
	doexe $(find bin/ -type f ! -iname '*.bat')
	dodir /usr/bin
	for b in $(find bin/ -type f ! -iname '*.bat'); do
		local _name=$(basename "${b}")
		dosym "${SCALADIR}/bin/${_name}" "/usr/bin/${_name}-${SV}"
	done
	popd || die
	java-pkg_dojar $(find "${WORKDIR}"/.ivy2/local -name \*.jar -print)

	pushd build/quick/classes/scala-dist/man/man1 || die
	for i in *.1; do
		newman "${i}" "${i/./-${SV}.}"
	done
	popd || die

	#sources are .scala so no use for java-pkg_dosrc
	pushd src || die
	if use source; then
		dodir "${SCALADIR}/src"
		insinto "${SCALADIR}/src"
		doins -r library library-aux reflect
	fi
	popd || die

	local DOCS=( "doc/README" )
	local HTML_DOCS=( "build/scaladoc" )
	einstalldocs
}
