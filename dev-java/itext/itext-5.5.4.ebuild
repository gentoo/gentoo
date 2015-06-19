# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/itext/itext-5.5.4.ebuild,v 1.2 2015/01/12 17:46:51 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library that generate documents in the Portable Document Format (PDF) and/or HTML."
HOMEPAGE="http://itextpdf.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="AGPL-3"
SLOT="5"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/bcmail:0
	>=dev-java/bcprov-1.49:0
	dev-java/bcpkix:0
	dev-java/xml-security:0
"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="bcmail,bcprov,bcpkix,xml-security"

java_prepare() {
	mkdir source || die

	for x in *-sources.jar; do
		unzip -n ${x} -d source || die
	done

	rm -v *.jar || die

	mkdir target/classes/com/itextpdf/text/pdf/fonts -p || die
	cp source/com/itextpdf/text/pdf/fonts/*{afm,html,txt} target/classes/com/itextpdf/text/pdf/fonts/ || die
	mkdir target/classes/com/itextpdf/text/l10n/ -p || die
	cp -r source/com/itextpdf/text/l10n/* target/classes/com/itextpdf/text/l10n/ || die
}
