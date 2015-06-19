# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/juel/juel-2.1.0.ebuild,v 1.7 2014/08/10 20:20:17 slyfox Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JUEL is an implementation of the Unified Expression Language (EL), a part of JSP 2.1 (JSR-245)"
HOMEPAGE="http://juel.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
		app-arch/unzip"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar || die "Unable to remove jars"
}

EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="apidoc"

src_install() {
	java-pkg_newjar "${P}.jar"
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/api/* src/impl/*
}
