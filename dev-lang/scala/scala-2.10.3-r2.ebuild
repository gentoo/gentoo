# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"
JAVA_ANT_DISABLE_ANT_CORE_DEP="yes"
EANT_TEST_TARGET="test.suite"

inherit eutils check-reqs java-pkg-2 java-ant-2 versionator

MY_P="${PN}-sources-${PV}"
SV="$(get_version_component_range 1-2)"

# creating the binary:
# JAVA_PKG_FORCE_VM="$available-1.6" USE="doc examples source" ebuild scala-*.ebuild compile
# cd $WORDKIR
# fix dist/latest link.
# tar -cjf $DISTDIR/scala-$PN-gentoo-binary.tar.bz2 ${MY_P}/dists ${MY_P}/docs/TODO

# In the pullJarFiles function in tools/binary-repo-lib.sh it executes find commands
# to search for .desired.sha1 files, which contain sha1 hashes that are appended
# to ${BURI} along with the subdirectory and filename to form the list of jar files
# listed in SRC_URI.  The output of this find command can be hacked into the desired format:
# find . -name \*.desired.sha1 -exec sed -e 's@\([0-9a-f]*\).*@\1@' {} \; -print
# After editing it into the desired format: sort -t / -k 3 file

BURI="http://repo.typesafe.com/typesafe/scala-sha-bootstrap/org/scala-lang/bootstrap"

declare -a JURI=( \
	${BURI}/8b6ba65c8146217333f0762087fe2340d572e832/docs/examples/plugintemplate/lib/scalatest.jar \
	${BURI}/943cd5c8802b2a3a64a010efb86ec19bac142e40/lib/ant/ant-contrib.jar \
	${BURI}/3fc1e35ca8c991fc3488548f7a276bd9053c179d/lib/ant/ant-dotnet-1.0.jar \
	${BURI}/7b456ca6b93900f96e58cc8371f03d90a9c1c8d1/lib/ant/ant.jar \
	${BURI}/7e50e3e227d834695f1e0bf018a7326e06ee4c86/lib/ant/maven-ant-tasks-2.1.1.jar \
	${BURI}/2c61d6e9a912b3253194d5d6d3e1db7e2545ac4b/lib/ant/vizant.jar \
	${BURI}/8acc87f222210b4a5eb2675477602fc1759e7684/lib/fjbg.jar \
	${BURI}/ddd7d5398733c4fbbb8355c049e258d47af636cf/lib/forkjoin.jar \
	${BURI}/a5261e70728c1847639e2b47d953441d0b217bcb/lib/jline.jar \
	${BURI}/d48cb950ceded82a5e0ffae8ef2c68d0923ed00c/lib/msil.jar \
	${BURI}/cfa3ee21f76cd5c115bd3bc070a3b401587bafb5/lib/scala-compiler-src.jar \
	${BURI}/d54b99f215d4d42b3f0b3489fbb1081270700992/lib/scala-compiler.jar \
	${BURI}/8bdac1cdd60b73ff7e12fd2b556355fa10343e2d/lib/scala-library-src.jar \
	${BURI}/1e0e39fae15b42e85998740511ec5a3830e26243/lib/scala-library.jar \
	${BURI}/d229f4c91ea8ab1a81559b5803efd9b0b1632f0b/lib/scala-reflect-src.jar
	${BURI}/288f47dbe1002653e030fd25ca500b9ffe1ebd64/lib/scala-reflect.jar \
	${BURI}/0392ecdeb306263c471ce51fa368223388b82b61/test/benchmarks/lib/jsr166_and_extra.jar \
	${BURI}/e737b123d31eede5594ceda07caafed1673ec472/test/files/codelib/code.jar \
	${BURI}/02fe2ed93766323a13f22c7a7e2ecdcd84259b6c/test/files/lib/annotations.jar \
	${BURI}/981392dbd1f727b152cd1c908c5fce60ad9d07f7/test/files/lib/enums.jar \
	${BURI}/b1ec8a095cec4902b3609d74d274c04365c59c04/test/files/lib/genericNest.jar \
	${BURI}/be8454d5e7751b063ade201c225dcedefd252775/test/files/lib/methvsfield.jar \
	${BURI}/cd33e0a0ea249eb42363a2f8ba531186345ff68c/test/files/lib/nest.jar \
	${BURI}/b6f4dbb29f0c2ec1eba682414f60d52fea84f703/test/files/lib/scalacheck.jar \
	${BURI}/1b11ac773055c1e942c6b5eb4aabdf02292a7194/test/files/speclib/instrumented.jar \
	${BURI}/f174c50c4363c492362a05c72dd45b0da18fdcd8/test/pending/neg/plugin-after-terminal/lib/plugins.jar \
	${BURI}/d7b100ad483484b598b7cd643424bd2e33898a0d/test/pending/neg/plugin-before-parser/lib/plugins.jar \
	${BURI}/7e6be9e33a87194e7061f94f6be115619f91ada2/test/pending/neg/plugin-cyclic-dependency/lib/plugins.jar \
	${BURI}/2bda582b574287429ad5ee2e1d9a3effc88b0a5f/test/pending/neg/plugin-multiple-rafter/lib/plugins.jar \
	${BURI}/af91fd67ccef349e7f8ea662615e17796a339485/test/pending/neg/plugin-rafter-before-1/lib/plugins.jar \
	${BURI}/8cccde4914da2058dca893783c231cda23855603/test/pending/neg/plugin-rightafter-terminal/lib/plugins.jar \
	${BURI}/a1883f4304d5aa65e1f6ee6aad5900c62dd81079/tools/push.jar \
)

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="http://www.scala-lang.org/"
SRC_URI="!binary?
(	https://github.com/scala/scala/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${JURI[@]}
	https://dev.gentoo.org/~gienah/snapshots/${P}-maven-deps.tar.gz
	https://dev.gentoo.org/~gienah/snapshots/${P}-maven-deps-2.tar.gz
)
binary? ( https://dev.gentoo.org/~gienah/files/dist/${P}-gentoo-binary.tar.bz2 )"

LICENSE="BSD"
SLOT="${SV}/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"

IUSE="binary emacs"

COMMON_DEP="dev-java/ant-core:0
	dev-java/hawtjni-runtime:0"

DEPEND="${COMMON_DEP}
	=virtual/jdk-1.7*
	java-virtuals/jdk-with-com-sun:0
	!binary? (
		dev-java/ant-core:0
		dev-java/ant-contrib:0
		dev-java/ant-nodeps:0
	)
	app-arch/xz-utils:0"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.7
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
	if use binary ; then
		mkdir -p "${S}" || die
		cd "${S}" || die
	fi

	# Unpack tar files only.
	for f in ${A} ; do
		[[ ${f} == *".tar."* ]] && unpack ${f}
	done
}

java_prepare() {
	java-pkg_getjars ant-core,hawtjni-runtime

	if ! use binary; then
		local j
		for j in "${JURI[@]}"
		do
			cp -p "${DISTDIR}/${j##*/}" "${S}/${j#${BURI}/*/}" || die
		done
		# gentoo patch (by gienah) to stop it calling git log in the build
		epatch "${FILESDIR}/${P}-no-git.patch"
		if java-pkg_is-vm-version-ge "1.7" ; then
			# This patch bumped to 2.10.2: http://pkgs.fedoraproject.org/cgit/scala.git/tree/scala-2.10.0-java7.patch
			epatch "${FILESDIR}/${PN}-2.10.2-jdk-1.7-swing.patch"
			sed -e "s@above is a message from the scala 2.10.2 release@above is a message from the scala ${PV} release@" \
				-i "${S}/build.xml" \
				|| die "Could not correct scala version message"
		fi
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

		# Remove this test as it fails.
		#   [partest] testing: [...]/files/run/parserJavaIdent.scala                        [FAILED]
		rm -f test/files/run/parserJavaIdent.scala
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
		eant -Djavac.args="-encoding UTF-8" -Djava6.home=${JAVA_HOME} \
			-Duser.home="${WORKDIR}" build-opt
		eant dist.done
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

	#sources are .scala so no use for java-pkg_dosrc
	if use source; then
		dodir "${SCALADIR}/src"
		insinto "${SCALADIR}/src"
		doins src/*-src.jar
	fi

	java-pkg_dojar lib/*.jar

	pushd man/man1 || die
	for i in *.1; do
		newman "${i}" "${i/./-${SV}.}"
	done
	popd

	local docdir="doc/${PN}-devel-docs"
	dodoc doc/README ../../docs/TODO
	if use doc; then
		java-pkg_dojavadoc "${docdir}/api"
		dohtml -r "${docdir}/tools"
	fi

	use examples && java-pkg_doexamples "${docdir}/examples"

	dodir /usr/bin
	for b in $(find bin/ -type f ! -iname '*.bat'); do
		local _name=$(basename "${b}")
		dosym "/usr/share/${PN}-${SV}/bin/${_name}" "/usr/bin/${_name}-${SV}"
	done
}
