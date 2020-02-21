# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

MY_P="${PN}$(ver_rs 1- '')"

DESCRIPTION="InterProlog is a Java front-end and enhancement for Prolog"
HOMEPAGE="http://www.declarativa.com/interprolog/"
SRC_URI="http://www.declarativa.com/interprolog/interprolog212.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=virtual/jdk-1.4:=
	dev-java/junit:0"

DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	|| (
		dev-lang/xsb
		dev-lang/swi-prolog
		dev-lang/yap )"

S="${WORKDIR}"/${MY_P}

EANT_GENTOO_CLASSPATH="junit"

src_prepare() {
	eapply "${FILESDIR}"/${P}-java1.4.patch
	eapply_user

	cp "${FILESDIR}"/build.xml "${S}" || die
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
		dodoc INSTALL.htm faq.htm prologAPI.htm
		dodoc -r images
		dodoc PaperEPIA01.doc
	fi
}
