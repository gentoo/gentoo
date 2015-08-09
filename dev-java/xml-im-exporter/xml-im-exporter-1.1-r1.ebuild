# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="XML Im-/Exporter is a library to assist you in the process of importing and exporting XML"
HOMEPAGE="http://xml-im-exporter.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${PN}"

EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar "lib/${PN}${PV}.jar"

	dodoc Changes.txt Open-Issues.txt Readme.txt Version.txt
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/main/*
}
