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
# tar -cjf scala-2.9.3-gentoo-binary.tar.bz2 scala-2.9.3/dists \
# scala-2.9.3//docs/TODO

# In the pullJarFiles function in tools/binary-repo-lib.sh it executes find commands
# to search for .desired.sha1 files, which contain sha1 hashes that are appended
# to ${BURI} along with the subdirectory and filename to form the list of jar files
# listed in SRC_URI.  The output of this find command can be hacked into the desired format:
# find . -name \*.desired.sha1 -exec sed -e 's@\([0-9a-f]*\).*@\1@' {} \; -print
# After editing it into the desired format: sort -t / -k 3 file

BURI="http://repo.typesafe.com/typesafe/scala-sha-bootstrap/org/scala-lang/bootstrap"

declare -a JURI=(
	"${BURI}/8b6ba65c8146217333f0762087fe2340d572e832/docs/examples/plugintemplate/lib/scalatest.jar -> ${P}-scalatest.jar"
	"${BURI}/7b456ca6b93900f96e58cc8371f03d90a9c1c8d1/lib/ant/ant.jar -> ${P}-ant.jar"
	"${BURI}/3fc1e35ca8c991fc3488548f7a276bd9053c179d/lib/ant/ant-dotnet-1.0.jar -> ${P}-ant-dotnet-1.0.jar"
	"${BURI}/943cd5c8802b2a3a64a010efb86ec19bac142e40/lib/ant/ant-contrib.jar -> ${P}-ant-contrib.jar"
	"${BURI}/7e50e3e227d834695f1e0bf018a7326e06ee4c86/lib/ant/maven-ant-tasks-2.1.1.jar -> ${P}-maven-ant-tasks-2.1.1.jar"
	"${BURI}/2c61d6e9a912b3253194d5d6d3e1db7e2545ac4b/lib/ant/vizant.jar -> ${P}-vizant.jar"
	"${BURI}/12c479a33ee283599fdb7aa91d6a1df0197a52cf/lib/forkjoin.jar -> ${P}-forkjoin.jar"
	"${BURI}/bd8e22a955eeb82671c5fdb8a7a14bc7f25e9eb1/lib/fjbg.jar -> ${P}-fjbg.jar"
	"${BURI}/545b37930819a1196705e582a232abfeb252cc8d/lib/jline.jar -> ${P}-jline.jar"
	"${BURI}/6597e6f74113e952a4233c451c973f5ac7f2b705/lib/midpapi10.jar -> ${P}-midpapi10.jar"
	"${BURI}/58f64cd00399c724e7d526e5bdcbce3e2b79f78b/lib/msil.jar -> ${P}-msil.jar"
	"${BURI}/5f31fab985a3efc21229297810c625b0a2593757/lib/scala-compiler.jar -> ${P}-scala-compiler.jar"
	"${BURI}/c52dbed261e4870a504cef24518484b335a38067/lib/scala-library.jar -> ${P}-scala-library.jar"
	"${BURI}/364c3b992bdebeac9fafb187e1acbece45644de7/lib/scala-library-src.jar -> ${P}-scala-library-src.jar"
	"${BURI}/0392ecdeb306263c471ce51fa368223388b82b61/test/benchmarks/lib/jsr166_and_extra.jar -> ${P}-jsr166_and_extra.jar"
	"${BURI}/02fe2ed93766323a13f22c7a7e2ecdcd84259b6c/test/files/lib/annotations.jar -> ${P}-annotations.jar"
	"${BURI}/981392dbd1f727b152cd1c908c5fce60ad9d07f7/test/files/lib/enums.jar -> ${P}-enums.jar"
	"${BURI}/b1ec8a095cec4902b3609d74d274c04365c59c04/test/files/lib/genericNest.jar -> ${P}-genericNest.jar"
	"${BURI}/be8454d5e7751b063ade201c225dcedefd252775/test/files/lib/methvsfield.jar -> ${P}-methvsfield.jar"
	"${BURI}/cd33e0a0ea249eb42363a2f8ba531186345ff68c/test/files/lib/nest.jar -> ${P}-nest.jar"
	"${BURI}/77dca656258fe983ec64461860ab1ca0f7e2fd65/test/files/lib/scalacheck.jar -> ${P}-scalacheck.jar"
	"${BURI}/2546f965f6718b000c4e6ef73559c11084177bd8/test/files/speclib/instrumented.jar -> ${P}-instrumented.jar"
	"${BURI}/f174c50c4363c492362a05c72dd45b0da18fdcd8/test/pending/neg/plugin-after-terminal/lib/plugins.jar -> ${P}-plugins.jar"
	"${BURI}/d7b100ad483484b598b7cd643424bd2e33898a0d/test/pending/neg/plugin-before-parser/lib/plugins.jar -> ${P}-plugins.jar"
	"${BURI}/7e6be9e33a87194e7061f94f6be115619f91ada2/test/pending/neg/plugin-cyclic-dependency/lib/plugins.jar -> ${P}-plugins.jar"
	"${BURI}/2bda582b574287429ad5ee2e1d9a3effc88b0a5f/test/pending/neg/plugin-multiple-rafter/lib/plugins.jar -> ${P}-plugins.jar"
	"${BURI}/af91fd67ccef349e7f8ea662615e17796a339485/test/pending/neg/plugin-rafter-before-1/lib/plugins.jar -> ${P}-plugins.jar"
	"${BURI}/8cccde4914da2058dca893783c231cda23855603/test/pending/neg/plugin-rightafter-terminal/lib/plugins.jar -> ${P}-plugins.jar"
	"${BURI}/ee000286d00c5209d5644462c1cfea87fc8b1342/test/pending/pos/t1380/gnujaxp.jar -> ${P}-gnujaxp.jar"
	"${BURI}/a1883f4304d5aa65e1f6ee6aad5900c62dd81079/tools/push.jar -> ${P}-push.jar"
)

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="http://www.scala-lang.org/"
SRC_URI="!binary?
(	https://github.com/scala/scala/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${JURI[@]}
)
binary? ( https://dev.gentoo.org/~gienah/files/dist/${P}-gentoo-binary.tar.bz2 )"

LICENSE="BSD"
SLOT="${SV}/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"

IUSE="binary emacs examples"

COMMON_DEP="dev-java/ant-core:0
	dev-java/hawtjni-runtime:0"

DEPEND="${COMMON_DEP}
	!binary? (
		=virtual/jdk-1.7*
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
	>=virtual/jre-1.7
	app-eselect/eselect-scala
	!dev-lang/scala-bin:0"

PDEPEND="emacs? ( app-emacs/scala-mode:0 )"

S="${WORKDIR}/${P}"

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
		epatch "${FILESDIR}/${PN}-2.9.2-java7.patch"
		# gentoo patch (by gienah) to stop it calling git log in the build
		epatch "${FILESDIR}/${P}-no-git.patch"
		# Note: to bump scala, some things to try are:
		# 1. update all the sha1s in JURI
		# 2. remove the https://dev.gentoo.org/~gienah/snapshots/${P}-maven-deps.tar.gz from SRC_URI
		# 3. try emerge scala.  Check if it downloads more stuff in src_compile to ${WORKDIR}/.m2
		# or /var/tmp/portage/.m2 or /root/.m2
		# 4. tar up all the .m2 junk into ${P}-maven-deps.tar.gz and add it to SRC_URI.
		sed -e 's@-Xmx1024M@-Xmx1536M@' \
			-e 's@-XX:MaxPermSize=128M@-XX:MaxPermSize=256M@' \
			-i "${S}/test/partest" \
			|| die "Could not change increase memory size in ${S}/test/partest"
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
	cd dists/latest || die
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

	#sources are .scala so no use for java-pkg_dosrc
	if use source; then
		dodir "${SCALADIR}/src"
		insinto "${SCALADIR}/src"
		doins src/*-src.jar
	fi

	local docdir="doc/${PN}-devel-docs"
	dodoc doc/README ../../docs/TODO || die
	if use doc; then
		java-pkg_dojavadoc "${docdir}/api"
		dohtml -r "${docdir}/tools" || die
	fi

	use examples && java-pkg_doexamples "${docdir}/examples"
}
