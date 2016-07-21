# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Swiss Army Knife for PDF files"
HOMEPAGE="http://jpdftweak.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="dev-java/itext:0
	dev-java/jgoodies-forms:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip:0
	${COMMON_DEPEND}"

S="${WORKDIR}"

java_prepare() {
	cd lib || die

	java-pkg_jar-from jgoodies-forms forms.jar
	java-pkg_jar-from itext iText.jar itext.jar
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --main ${PN}.Main

	dodoc README.txt
	dohtml manual/*
}
