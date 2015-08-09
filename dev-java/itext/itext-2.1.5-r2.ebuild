# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DISTFILE="${PN/it/iT}-src-${PV}.tar.gz"
ASIANJAR="iTextAsian.jar"
ASIANCMAPSJAR="iTextAsianCmaps.jar"

DESCRIPTION="A Java library that generate documents in the Portable Document Format (PDF) and/or HTML"
HOMEPAGE="http://www.lowagie.com/iText/"
SRC_URI="mirror://sourceforge/itext/${DISTFILE}
	cjk? ( mirror://sourceforge/itext/${ASIANJAR}
		mirror://sourceforge/itext/${ASIANCMAPSJAR} )"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="cjk rtf rups"

BCV="1.45"

COMMON_DEPEND="
	dev-java/bcmail:${BCV}
	dev-java/bcprov:${BCV}
	rups? (
		dev-java/dom4j:1
		dev-java/pdf-renderer:0
	)"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.5
	cjk? ( app-arch/unzip )"

S="${WORKDIR}/src"

src_unpack() {
	unpack ${DISTFILE}
}

java_prepare() {
	sed -i -e 's|<link href="http://java.sun.com/j2se/1.4/docs/api/" />||' \
		-e 's|<link href="http://www.bouncycastle.org/docs/docs1.4/" />||' \
		"${S}/ant/site.xml"

	java-ant_bsfix_files ant/*.xml || die "failed to rewrite build xml files"
}

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_ENCODING="utf8"

src_compile() {
	EANT_GENTOO_CLASSPATH="bcmail-${BCV},bcprov-${BCV}"
	use rups && EANT_GENTOO_CLASSPATH+=",dom4j-1,pdf-renderer"

	java-pkg-2_src_compile \
		$(use rtf && echo "jar.rtf") \
		$(use rups && echo "jar.rups")
}

src_install() {
	cd "${WORKDIR}"
	java-pkg_dojar lib/iText.jar
	use rtf && java-pkg_dojar lib/iText-rtf.jar
	use rups && java-pkg_dojar lib/iText-rups.jar
	if use cjk; then
		java-pkg_dojar "${DISTDIR}/${ASIANJAR}"
		java-pkg_dojar "${DISTDIR}/${ASIANCMAPSJAR}"
	fi

	use source && java-pkg_dosrc src/core/com src/rups/com
	use doc && java-pkg_dojavadoc build/docs
}
