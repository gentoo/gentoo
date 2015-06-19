# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/freetts/freetts-1.2.1-r2.ebuild,v 1.5 2012/03/06 21:33:37 ranger Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A speech synthesis system written entirely in Java"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
HOMEPAGE="http://freetts.sourceforge.net/"

RDEPEND=">=virtual/jre-1.4
	mbrola? ( >=app-accessibility/mbrola-3.0.1h-r6 ) "
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	jsapi? ( app-arch/sharutils )
	app-arch/unzip"

LICENSE="jsapi? ( sun-bcla-jsapi ) freetts"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc jsapi mbrola"

src_unpack() {
	unpack ${A}
	cd "${S}/lib"

	chmod 0755 jsapi.sh
	epatch "${FILESDIR}/jsapi-gentoo.diff"

	use mbrola && echo "mbrola.base=/usr/share/mbrola/" >> "${S}/speech.properties"
}

src_compile() {
	cd "${S}/lib"
	if use jsapi; then
		./jsapi.sh || die "jsapi.sh failed"
	fi
	cd "${S}"
	eant jars
}

# Tests dont' seem included
# http://freetts.sourceforge.net/docs/index.php#how_test
#src_test() {
#	ANT_TASKS="ant-junit" eant junit
#}

src_install() {
	java-pkg_dojar lib/*.jar mbrola/*.jar

	use mbrola && local jflags="--java_args -Dmbrola.base=/usr/share/mbrola"
	java-pkg_dolauncher ${PN} --main com.sun.speech.freetts.FreeTTS ${jflags}

	insinto /usr/share/${PN}
	doins speech.properties

	cp -R "${S}/demo" "${D}/usr/share/${PN}"
	cp -R "${S}/tools" "${D}/usr/share/${PN}"

	dodoc README.txt RELEASE_NOTES acknowledgments.txt || die
	if use doc; then
		insinto /usr/share/doc/${PF}/html
		doins -r "${S}"/docs/*
		java-pkg_dojavadoc "${S}/javadoc"
	fi
}
