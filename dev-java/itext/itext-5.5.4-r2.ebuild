# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library that generate documents in the Portable Document Format (PDF) and/or HTML."
HOMEPAGE="http://itextpdf.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="AGPL-3"
SLOT="5"
KEYWORDS="~amd64 ~x86"

BC_SLOT="1.52"

CDEPEND="dev-java/bcmail:${BC_SLOT}
	dev-java/bcpkix:${BC_SLOT}
	dev-java/bcprov:${BC_SLOT}
	dev-java/xml-security:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="
	bcmail-${BC_SLOT}
	bcpkix-${BC_SLOT}
	bcprov-${BC_SLOT}
	xml-security"

PATCHES=(
	"${FILESDIR}"/${P}-OcspClientBouncyCastle.java.patch
)

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

	epatch "${PATCHES[@]}"
}
