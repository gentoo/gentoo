# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/octopus/octopus-3.0.1-r4.ebuild,v 1.1 2015/04/05 21:05:29 monsieurp Exp $

EAPI=5
JAVA_PKG_IUSE="doc source"
JAVA_PKG_WANT_BOOTCLASSPATH="1.5"

inherit versionator java-pkg-2 java-ant-2

MY_PV=${PV//./-}
MY_PV=${MY_PV/-/.}
DESCRIPTION="A Java-based Extraction, Transformation, and Loading (ETL) tool"
SRC_URI="http://download.forge.objectweb.org/${PN}/${PN}-${MY_PV}.src.tar.gz
	mirror://gentoo/${PN}-xmls-${PV}.tar.bz2"
HOMEPAGE="http://octopus.objectweb.org"
LICENSE="LGPL-2.1"
SLOT="3.0"
KEYWORDS="~amd64 ~x86"
IUSE=""
COMMON_DEP="
	>=dev-java/xerces-2.7
	>=dev-java/log4j-1.2.8
	=dev-java/rhino-1.6*
	=dev-java/junit-3.8*
	>=dev-java/ant-core-1.4"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
	${COMMON_DEP}"

# uses enum as identifier
JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"

TOPDIR="${PN}-$(get_version_component_range 1-2)"
S=${WORKDIR}/${TOPDIR}/Octopus-src

java_prepare() {
	rm -fr ${TOPDIR}/maven || die
	mv "${WORKDIR}/xmls" "${S}/modules/Octopus" || die
	cd "${S}"/modules || die

	cp "${FILESDIR}/${P}-gentoo-build.xml" build.xml || die
	java-ant_rewrite-classpath build.xml
	java-pkg_filter-compiler jikes
	java-ant_rewrite-bootclasspath 1.5

	epatch "${FILESDIR}/${PN}-jdk-1.5.patch"
}

EANT_GENTOO_CLASSPATH="xerces-2,rhino-1.6,ant-core,junit,log4j"

src_compile() {
	cd "${S}/modules" || die

	use source && antflags="${antflags} sourcezip-all"

	eant jar-all $(use_doc docs-all) ${antflags}
}

RESTRICT="test"

# Would need maven to work properly as the build.xml just launches maven
#src_test() {
#	eant test
#}

src_install() {
	dodoc ChangeLog.txt ReleaseNotes.txt

	cd "${S}/modules" || die
	java-pkg_dojar dist/*.jar

	if use source; then
		dodir /usr/share/doc/${PF}/source
		cp dist/*-src.zip "${D}usr/share/doc/${PF}/source"
	fi

	if use doc; then
		docinto html/api
		# Has multiple javadoc subdirs here
		java-pkg_dohtml -r docs/*
	fi
}
