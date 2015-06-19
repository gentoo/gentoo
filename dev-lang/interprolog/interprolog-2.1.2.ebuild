# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/interprolog/interprolog-2.1.2.ebuild,v 1.4 2008/06/03 06:33:32 keri Exp $

inherit eutils java-pkg-2 java-ant-2 versionator

MY_PV="$(delete_all_version_separators)"
MY_P="${PN}${MY_PV}"

DESCRIPTION="InterProlog is a Java front-end and enhancement for Prolog"
HOMEPAGE="http://www.declarativa.com/interprolog/"
SRC_URI="http://www.declarativa.com/interprolog/interprolog212.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	dev-java/ant-core
	=dev-java/junit-3.8*"

RDEPEND=">=virtual/jdk-1.4
	=dev-java/junit-3.8*
	|| (
		dev-lang/xsb
		dev-lang/swi-prolog
		dev-lang/yap )"

S="${WORKDIR}"/${MY_P}

EANT_GENTOO_CLASSPATH="junit"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-java1.4.patch

	cp "${FILESDIR}"/build.xml "${S}"
	mkdir "${S}"/src
	mv "${S}"/com "${S}"/src
	rm interprolog.jar junit.jar
}

src_compile() {
	java-pkg_jar-from junit
	eant jar $(use_doc)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	if use doc ; then
		java-pkg_dohtml -r docs/*
		dohtml INSTALL.htm faq.htm prologAPI.htm
		dohtml -r images
		dodoc PaperEPIA01.doc
	fi
}
