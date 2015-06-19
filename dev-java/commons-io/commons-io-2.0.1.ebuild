# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-io/commons-io-2.0.1.ebuild,v 1.7 2014/08/10 20:11:05 slyfox Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

MY_P="${P}-src"
DESCRIPTION="Commons-IO contains utility classes, stream implementations, file filters, and endian classes"
HOMEPAGE="http://commons.apache.org/io/"
SRC_URI="mirror://apache/commons/io/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit )"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_ignore-system-classes
	java-ant_rewrite-classpath
	# Setting java.io.tmpdir doesn't have effect unless we do this because the
	# vm is forked
	java-ant_xml-rewrite -f build.xml --change -e junit -a clonevm -v "true"
}

EANT_EXTRA_ARGS="-Duser.home=${T}"

src_test() {
	if [[ ${EUID} -ne 0 ]]; then
		ANT_OPTS="-Djava.io.tmpdir=${T} -Duser.home=${T}" \
		ANT_TASKS="ant-junit" \
			eant test \
			-Dgentoo.classpath="$(java-pkg_getjars junit)" \
			-Dlibdir="libdir" \
			-Djava.io.tmpdir="${T}"
	else
		elog "Tests fail unless userpriv is enabled because they test for"
		elog "file permissions which doesn't work when run as root."
	fi
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	dodoc RELEASE-NOTES.txt NOTICE.txt || die
	use doc && java-pkg_dojavadoc target/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
