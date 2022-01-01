# Copyright 2016-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="GNU Prolog for Java is an implementation of ISO Prolog as a Java library"
HOMEPAGE="https://www.gnu.org/software/gnuprologjava"
SRC_URI="mirror://gnu/gnuprologjava/${P}-src.zip"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

BDEPEND="app-arch/unzip"
RDEPEND=">=virtual/jdk-1.6:="
DEPEND="${RDEPEND}
	dev-java/ant-core"

S="${WORKDIR}"

src_prepare() {
	eapply "${FILESDIR}"/${P}-manual.patch
	eapply_user
}

src_compile() {
	eant jar
	if use doc ; then
		eant doc
	fi
	mv build/${P}.jar build/${PN}.jar || die
}

src_install() {
	java-pkg_dojar build/${PN}.jar

	if use doc ; then
		java-pkg_dohtml -r build/api || die
		java-pkg_dohtml -r build/manual || die
	fi

	dodoc NEWS.txt docs/readme.txt
}
