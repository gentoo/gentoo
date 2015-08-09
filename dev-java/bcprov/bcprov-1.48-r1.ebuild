# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-jdk15on-${PV/./}"
DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1.48"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos"

# The src_unpack find needs a new find
# https://bugs.gentoo.org/show_bug.cgi?id=182276
DEPEND=">=virtual/jdk-1.5
	userland_GNU? ( >=sys-apps/findutils-4.3 )
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

IUSE="userland_GNU"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	default

	cd "${S}" || die
	unpack ./src.zip
}

java_prepare() {
	# This should eventually split the tests
	# and call them separately, it's not clean
	# to just throw the tests away.
	einfo "Removing testcases' sources:"
	find . -path '*test/*.java' -print -delete \
		|| die "Failed to delete testcases."
	find . -name '*Test*.java' -print -delete \
		|| die "Failed to delete testcases."

	mkdir "${S}"/classes || die
}

src_compile() {
	find . -name "*.java" > "${T}"/src.list
	ejavac -encoding ISO-8859-1 -d "${S}"/classes "@${T}"/src.list

	cd "${S}"/classes || die
	jar -cf "${S}"/${PN}.jar * || die "Failed to create jar."
}

src_install() {
	java-pkg_dojar "${S}"/${PN}.jar

	use source && java-pkg_dosrc org
	use doc && java-pkg_dojavadoc docs
}
