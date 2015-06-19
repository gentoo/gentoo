# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/scala/scala-2.9.2-r1.ebuild,v 1.2 2015/05/18 21:15:40 monsieurp Exp $

EAPI="5"
JAVA_PKG_IUSE="doc examples source"
WANT_ANT_TASKS="ant-nodeps"
inherit eutils check-reqs java-pkg-2 java-ant-2 versionator

MY_P="${PN}-sources-${PV}"
SV="$(get_version_component_range 1-2)"

# creating the binary:
# JAVA_PKG_FORCE_VM="$available-1.6" USE="doc examples source" ebuild scala-*.ebuild compile
# cd $WORDKIR
# fix dist/latest link.
# tar -cjf $DISTDIR/scala-$PN-gentoo-binary.tar.bz2 ${MY_P}/dists ${MY_P}/docs/TODO

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="http://www.scala-lang.org/"
SRC_URI="!binary? ( ${HOMEPAGE}downloads/distrib/files/${MY_P}.tgz -> ${P}.tar.gz )
	binary? ( http://dev.gentoo.org/~ali_bush/distfiles/${P}-gentoo-binary.tar.bz2 )"
LICENSE="BSD"
SLOT="${SV}/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="binary emacs"
# one fails with 1.7, two with 1.4 (blackdown)
#RESTRICT="test"

DEPEND="virtual/jdk:1.6
	java-virtuals/jdk-with-com-sun
	!binary? (
		dev-java/ant-contrib:0
	)
	app-arch/xz-utils"
RDEPEND=">=virtual/jre-1.6
	app-eselect/eselect-scala
	!dev-lang/scala-bin"

PDEPEND="emacs? ( app-emacs/scala-mode )"

S="${WORKDIR}/${P}-sources"

CHECKREQS_MEMORY="1532M"

pkg_setup() {
	java-pkg-2_pkg_setup

	if ! use binary; then
		debug-print "Checking for sufficient physical RAM"

		ewarn "This package can fail to build with memory allocation errors in some cases."
		ewarn "If you are unable to build from sources, please try USE=binary"
		ewarn "for this package. See bug #181390 for more information."

		CHECKREQS_MEMORY="1532M"

		check-reqs_pkg_setup
	fi
}

java_prepare() {
	if ! use binary; then
		pushd lib &> /dev/null
		# other jars are needed for bootstrap
		#rm -v jline.jar ant/ant-contrib.jar #cldcapi10.jar midpapi10.jar msil.jar *.dll || die
		rm -v ant/ant-contrib.jar || die
		java-pkg_jar-from --into ant --build-only ant-contrib
		popd &> /dev/null
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
			newlibs newforkjoin build-opt
		eant dist.done
	else
		einfo "Skipping compilation, USE=binary is set."
	fi
}

src_test() {
	eant test.suite || die "Some tests aren't passed"
}

#scala_launcher() {
#	local SCALADIR="${EPREFIX}/usr/share/${PN}"
#	local bcp="${EPREFIX}${SCALADIR}/lib/scala-library.jar"
#	java-pkg_dolauncher "${1}" --main "${2}" \
#		--java_args "-Xmx256M -Xms32M -Dscala.home=${SCALADIR} -Denv.emacs=${EMACS}"
#}

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
		dodoc doc/README ../../docs/TODO || die
		if use doc; then
			java-pkg_dojavadoc "${docdir}/api"
			dohtml -r "${docdir}/tools" || die
		fi

		use examples && java-pkg_doexamples "${docdir}/examples"
	fi

	dodir /usr/bin
	for b in $(find bin/ -type f ! -iname '*.bat'); do
		#pushd "${ED}/usr/bin" &>/dev/null
		local _name=$(basename "${b}")
		dosym "/usr/share/${PN}-${SV}/bin/${_name}" "/usr/bin/${_name}-${SV}"
		#popd &>/dev/null
	done
	#scala_launcher fsc scala.tools.nsc.CompileClient
	#scala_launcher scala scala.tools.nsc.MainGenericRunner
	#scala_launcher scalac scala.tools.nsc.Main
	#scala_launcher scaladoc scala.tools.nsc.ScalaDoc
	#scala_launcher scalap scala.tools.scalap.Main
}
