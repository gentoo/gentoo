# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"
JAVA_ANT_DISABLE_ANT_CORE_DEP="yes"
EANT_TEST_TARGET="test.suite"

inherit eutils check-reqs java-pkg-2 java-ant-2 versionator

MY_P="${PN}-sources-${PV}"
SV="$(get_version_component_range 1-2)"

# creating the binary:
# JAVA_PKG_FORCE_VM="$available-1.7" USE="doc source" ebuild scala-*.ebuild compile
# cd $WORDKIR
# tar -cjf scala-2.11.4-gentoo-binary.tar.bz2 scala-2.11.4/build/pack/bin \
# scala-2.11.4/build/pack/lib/ scala-2.11.4/build/pack/man \
# scala-2.11.4/src/actors/ scala-2.11.4/src/forkjoin/ \
# scala-2.11.4/src/library scala-2.11.4/src/library-aux/ \
# scala-2.11.4/src/reflect/ scala-2.11.4/docs/TODO \
# scala-2.11.4/doc/README scala-2.11.4/build/scaladoc/compiler

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
	"${BURI}/ddd7d5398733c4fbbb8355c049e258d47af636cf/lib/forkjoin.jar -> ${P}-forkjoin.jar"
	"${BURI}/0392ecdeb306263c471ce51fa368223388b82b61/test/benchmarks/lib/jsr166_and_extra.jar -> ${P}-jsr166_and_extra.jar"
	"${BURI}/e737b123d31eede5594ceda07caafed1673ec472/test/files/codelib/code.jar -> ${P}-code.jar"
	"${BURI}/02fe2ed93766323a13f22c7a7e2ecdcd84259b6c/test/files/lib/annotations.jar -> ${P}-annotations.jar"
	"${BURI}/981392dbd1f727b152cd1c908c5fce60ad9d07f7/test/files/lib/enums.jar -> ${P}-enums.jar"
	"${BURI}/b1ec8a095cec4902b3609d74d274c04365c59c04/test/files/lib/genericNest.jar -> ${P}-genericNest.jar"
	"${BURI}/346d3dff4088839d6b4d163efa2892124039d216/test/files/lib/jsoup-1.3.1.jar -> ${P}-jsoup-1.3.1.jar"
	"${BURI}/3794ec22d9b27f2b179bd34e9b46db771b934ec3/test/files/lib/macro210.jar -> ${P}-macro210.jar"
	"${BURI}/be8454d5e7751b063ade201c225dcedefd252775/test/files/lib/methvsfield.jar -> ${P}-methvsfield.jar"
	"${BURI}/cd33e0a0ea249eb42363a2f8ba531186345ff68c/test/files/lib/nest.jar -> ${P}-nest.jar"
	"${BURI}/1b11ac773055c1e942c6b5eb4aabdf02292a7194/test/files/speclib/instrumented.jar -> ${P}-instrumented.jar"
	"${BURI}/a1883f4304d5aa65e1f6ee6aad5900c62dd81079/tools/push.jar -> ${P}-push.jar"
)

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="http://www.scala-lang.org/"
SRC_URI="!binary?
(	https://github.com/scala/scala/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${JURI[@]}
	https://dev.gentoo.org/~gienah/snapshots/${P}-maven-deps.tar.gz
)
binary? ( https://dev.gentoo.org/~gienah/files/dist/${P}-gentoo-binary.tar.bz2 )"

LICENSE="BSD"
SLOT="${SV}/${PV}"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"

IUSE="binary emacs"

COMMON_DEP="dev-java/ant-core:0
	dev-java/hawtjni-runtime:0"

DEPEND="${COMMON_DEP}
	!binary? (
		|| ( =virtual/jdk-1.6* =virtual/jdk-1.7* =virtual/jdk-1.8* )
		dev-java/ant-core:0
		dev-java/ant-contrib:0
		dev-java/ant-nodeps:0
		media-gfx/graphviz
	)
	binary? (
		|| ( =virtual/jdk-1.7* =virtual/jdk-1.8* )
	)
	app-arch/xz-utils:0"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6
	app-eselect/eselect-scala
	!dev-lang/scala-bin:0"

PDEPEND="emacs? ( app-emacs/scala-mode:0 )"

S="${WORKDIR}/${P}"

CHECKREQS_MEMORY="1532M"

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

java_prepare() {
	java-pkg_getjars ant-core,hawtjni-runtime

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
		epatch "${FILESDIR}/${P}-no-git.patch"
		# Note: to bump scala, some things to try are:
		# 1. update all the sha1s in JURI
		# 2. remove the https://dev.gentoo.org/~gienah/snapshots/${P}-maven-deps.tar.gz from SRC_URI
		# 3. try emerge scala.  Check if it downloads more stuff in src_compile to ${WORKDIR}/.m2
		# or /var/tmp/portage/.m2 or /root/.m2
		# 4. tar up all the .m2 junk into ${P}-maven-deps.tar.gz and add it to SRC_URI.
		sed -e "s@\(<mkdir dir=\"\)\${user.home}\(/.m2/repository\"/>\)@\1${WORKDIR}\2\n      <artifact:localRepository id=\"localrepo\" path=\"${WORKDIR}/.m2/repository\" />@" \
			-e "s@\${user.home}/.m2@${WORKDIR}/.m2@g" \
			-e 's@\(<artifact:dependencies .*>\)@\1\n        <localRepository refid="localrepo" />@g' \
			-i "${S}/build.xml" \
			|| die "Could not change location of .m2 maven download directory in ${S}/build.xml"
	fi
}

src_compile() {
	if ! use binary; then
		#unset ANT_OPTS as this is set in the build.xml
		#sets -X type variables which might come back to bite me
		unset ANT_OPTS

		# reported in bugzilla that multiple launches use less resources
		# https://bugs.gentoo.org/show_bug.cgi?id=282023
		eant all.clean
		eant -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \
			fastdist-opt
		if use doc; then
			# The separate build for doc is to workaround this problem that occurs
			# with one "fastdist docscomp" build (still fails with MaxPermSize=384M)
			# java.lang.OutOfMemoryError: PermGen space
			eant -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \
				docscomp
			eant -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \
				docs
		fi
	else
		einfo "Skipping compilation, USE=binary is set."
	fi
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	pushd build/pack || die
	local SCALADIR="/usr/share/${PN}-${SV}"
	exeinto "${SCALADIR}/bin"
	doexe $(find bin/ -type f ! -iname '*.bat')
	dodir "${SCALADIR}/lib"
	insinto "${SCALADIR}/lib"
	pushd lib || die
	for j in *.jar; do
		local i="$(echo "${j}" | sed -e "s@[_-][0-9.-]*\.jar@.jar@")"
		newins "${j}" "${i}"
		java-pkg_regjar "${ED}${SCALADIR}/lib/${i}"
	done
	popd

	dodir /usr/bin
	for b in $(find bin/ -type f ! -iname '*.bat'); do
		local _name=$(basename "${b}")
		dosym "${SCALADIR}/bin/${_name}" "/usr/bin/${_name}-${SV}"
	done

	pushd man/man1 || die
	for i in *.1; do
		newman "${i}" "${i/./-${SV}.}"
	done
	popd
	popd

	#sources are .scala so no use for java-pkg_dosrc
	pushd src || die
	if use source; then
		dodir "${SCALADIR}/src"
		insinto "${SCALADIR}/src"
		doins -r actors forkjoin library library-aux reflect
	fi
	popd

	local docdir="build/scaladoc"
	dodoc docs/TODO doc/README
	if use doc; then
		dohtml -r "${docdir}"/{compiler,library}
	fi
}
