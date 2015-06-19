# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/scala/scala-2.10.2-r2.ebuild,v 1.3 2015/05/18 21:15:40 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source"
WANT_ANT_TASKS="ant-nodeps"
EANT_TEST_TARGET="test.suite"

inherit eutils check-reqs java-pkg-2 java-ant-2 versionator

MY_P="${PN}-sources-${PV}"
SV="$(get_version_component_range 1-2)"

# creating the binary:
# JAVA_PKG_FORCE_VM="$available-1.6" USE="doc examples source" ebuild scala-*.ebuild compile
# cd $WORDKIR
# fix dist/latest link.
# tar -cjf $DISTDIR/scala-$PN-gentoo-binary.tar.bz2 ${MY_P}/dists ${MY_P}/docs/TODO

# in the pullJarFiles function in tools/binary-repo-lib.sh it executes find commands
# to search for .desired.sha1 files, which contain sha1 hashes that are appended
# to ${BURI} along with the subdirectory and filename to form the list of jar files
# listed in SRC_URI.

BURI="http://repo.typesafe.com/typesafe/scala-sha-bootstrap/org/scala-lang/bootstrap"

declare -a JURI=(${BURI}/8bdac1cdd60b73ff7e12fd2b556355fa10343e2d/lib/scala-library-src.jar \
	${BURI}/ddd7d5398733c4fbbb8355c049e258d47af636cf/lib/forkjoin.jar \
	${BURI}/d48cb950ceded82a5e0ffae8ef2c68d0923ed00c/lib/msil.jar \
	${BURI}/d229f4c91ea8ab1a81559b5803efd9b0b1632f0b/lib/scala-reflect-src.jar \
	${BURI}/3fc1e35ca8c991fc3488548f7a276bd9053c179d/lib/ant/ant-dotnet-1.0.jar \
	${BURI}/2c61d6e9a912b3253194d5d6d3e1db7e2545ac4b/lib/ant/vizant.jar \
	${BURI}/7b456ca6b93900f96e58cc8371f03d90a9c1c8d1/lib/ant/ant.jar \
	${BURI}/943cd5c8802b2a3a64a010efb86ec19bac142e40/lib/ant/ant-contrib.jar \
	${BURI}/7e50e3e227d834695f1e0bf018a7326e06ee4c86/lib/ant/maven-ant-tasks-2.1.1.jar \
	${BURI}/cfa3ee21f76cd5c115bd3bc070a3b401587bafb5/lib/scala-compiler-src.jar \
	${BURI}/1e0e39fae15b42e85998740511ec5a3830e26243/lib/scala-library.jar \
	${BURI}/8acc87f222210b4a5eb2675477602fc1759e7684/lib/fjbg.jar \
	${BURI}/288f47dbe1002653e030fd25ca500b9ffe1ebd64/lib/scala-reflect.jar \
	${BURI}/a5261e70728c1847639e2b47d953441d0b217bcb/lib/jline.jar \
	${BURI}/d54b99f215d4d42b3f0b3489fbb1081270700992/lib/scala-compiler.jar \
	${BURI}/02fe2ed93766323a13f22c7a7e2ecdcd84259b6c/test/files/lib/annotations.jar \
	${BURI}/b1ec8a095cec4902b3609d74d274c04365c59c04/test/files/lib/genericNest.jar \
	${BURI}/981392dbd1f727b152cd1c908c5fce60ad9d07f7/test/files/lib/enums.jar \
	${BURI}/cd33e0a0ea249eb42363a2f8ba531186345ff68c/test/files/lib/nest.jar \
	${BURI}/be8454d5e7751b063ade201c225dcedefd252775/test/files/lib/methvsfield.jar \
	${BURI}/b6f4dbb29f0c2ec1eba682414f60d52fea84f703/test/files/lib/scalacheck.jar \
	${BURI}/e737b123d31eede5594ceda07caafed1673ec472/test/files/codelib/code.jar \
	${BURI}/1b11ac773055c1e942c6b5eb4aabdf02292a7194/test/files/speclib/instrumented.jar \
	${BURI}/a1883f4304d5aa65e1f6ee6aad5900c62dd81079/tools/push.jar)

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="http://www.scala-lang.org/"
SRC_URI="!binary?
(	https://github.com/scala/scala/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${JURI[@]}
	http://dev.gentoo.org/~gienah/snapshots/${P}-maven-deps.tar.gz
)
binary? ( http://dev.gentoo.org/~tomwij/files/dist/${P}-gentoo-binary.tar.bz2 )"

LICENSE="BSD"
SLOT="${SV}/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"

IUSE="binary emacs"

COMMON_DEP="dev-java/ant-core:0
	dev-java/bndlib:0
	dev-java/hawtjni-runtime:0
	dev-java/junit:4"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.7.0
	<virtual/jdk-1.8.0
	java-virtuals/jdk-with-com-sun:0
	!binary? (
		dev-java/ant-contrib:0
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
	java-pkg_getjars ant-core,bndlib,hawtjni-runtime,junit-4

	if ! use binary; then
		local j
		for j in "${JURI[@]}"
		do
			cp -p "${DISTDIR}/${j##*/}" "${S}/${j#${BURI}/*/}" || die
		done
		# gentoo patch (by gienah) to stop it calling git log in the build
		epatch "${FILESDIR}/${PN}-2.10.2-no-git.patch"
		if has_version ">=virtual/jdk-1.7.0"; then
			# This patch bumped to 2.10.2: http://pkgs.fedoraproject.org/cgit/scala.git/tree/scala-2.10.0-java7.patch
			epatch "${FILESDIR}/${PN}-2.10.2-jdk-1.7-swing.patch"
		fi
		# https://issues.scala-lang.org/browse/SI-7455
		epatch "${FILESDIR}/${PN}-2.10.2-jdk-1.7-swing-SI-7455.patch"
		# Note: to bump scala, some things to try are:
		# 1. update all the sha1s in JURI
		# 2. comment out applying the maven-deps patch and all the stuff here up to and including the sed of build.xml
		# 3. try emerge scala, it will likely download more stuff in src_compile to ${WORKDIR}/.m2
		# 4. tar up the stuff in ${WORKDIR}/.m2 and change the ${P}-maven-deps.tar.gz in SRC_URI to point to it.
		# 5. uncomment the maven-deps patch apply and all the stuff up to and including the sed of build.xml
		# 6. the hash in ${P}-no-git.patch should be updated by searching for hash matching the scala release
		# tag, so that the source code hyper-links in the scala documentation will point to the correct version of
		# the source code.
		# Bug 482192
		epatch "${FILESDIR}/${PN}-2.10.2-maven-deps.patch"
		# we have $(java-config -p bndlib) in portage, but not bnd.
		local bnd_classpath=""
		for i in $(find "${WORKDIR}/.m2/repository/biz/aQute/bnd" -type f -name *.jar -print)
		do
			if [ -z "${bnd_classpath}" ]
			then
				bnd_classpath="${i}"
			else
				bnd_classpath="${bnd_classpath}:${i}"
			fi
		done
		bnd_classpath="${bnd_classpath}:$(java-config -p bndlib)"

		# pax runner appears to only be used in the tests
		local paxrunner_classpath=""
		for i in $(find "${WORKDIR}/.m2/repository/org/ops4j/" -type f -name *.jar -print)
		do
			if [ -z "${paxrunner_classpath}" ]
			then
				paxrunner_classpath="${i}"
			else
				paxrunner_classpath="${paxrunner_classpath}:${i}"
			fi
		done
		paxrunner_classpath="${paxrunner_classpath}:$(java-config -p junit-4)"

		# DiffUtils does not appear to be in portage.  It is placed in ${partest.extras.classpath} and
		# copied to ${build-pack.dir}/lib in ${PN}-2.10.2-maven-deps.patch.
		local diffutils_classpath=""
		for i in $(find "${WORKDIR}/.m2/repository/com/googlecode/java-diff-utils" -type f -name *.jar -print)
		do
			if [ -z "${diffutils_classpath}" ]
			then
				diffutils_classpath="${i}"
			else
				diffutils_classpath="${diffutils_classpath}:${i}"
			fi
		done

		sed -e "s@BNDLIB_CLASSPATH@${bnd_classpath}@" \
			-e "s@PAX_RUNNER_CLASSPATH@${paxrunner_classpath}@" \
			-e "s@DIFFUTILS_CLASSPATH@${diffutils_classpath}@" \
			-i "${S}/build.xml" \
			|| die "could not sed classpaths in build.xml"
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

	#docs and examples are not contained in the binary tgz anymore
	if ! use binary; then
		local docdir="doc/${PN}-devel-docs"
		dodoc doc/README ../../docs/TODO
		if use doc; then
			java-pkg_dojavadoc "${docdir}/api"
			dohtml -r "${docdir}/tools"
		fi

		use examples && java-pkg_doexamples "${docdir}/examples"
	fi

	dodir /usr/bin
	for b in $(find bin/ -type f ! -iname '*.bat'); do
		local _name=$(basename "${b}")
		dosym "/usr/share/${PN}-${SV}/bin/${_name}" "/usr/bin/${_name}-${SV}"
	done
}
