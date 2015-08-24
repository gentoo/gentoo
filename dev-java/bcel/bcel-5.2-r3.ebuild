# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="The Byte Code Engineering Library: analyze, create, manipulate Java class files"
HOMEPAGE="http://commons.apache.org/bcel/"
SRC_URI="mirror://apache/jakarta/${PN}/source/${P}-src.tar.gz
	findbugs? ( https://dev.gentoo.org/~fordfrog/distfiles/findbugs-${P}_p20070531.patch.bz2 )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="-findbugs"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

JAVA_ANT_ENCODING="ISO-8859-1"

ANT_OPTS="-Xmx256m"

java_prepare() {
	epatch "${FILESDIR}/${P}"-build.xml.patch
	if use findbugs; then
		# Remove next line if no longer needed. Removes build.xml from patch.
		patch -d "${WORKDIR}" -p0 < "${FILESDIR}"/findbugs-${P}_p20070531.patch.patch || die "Failed to patch"

		EPATCH_OPTS="-p7" epatch "${WORKDIR}"/findbugs-${P}_p20070531.patch
	fi
}

src_install() {
	java-pkg_newjar ./target/${P}.jar
	dodoc README.txt || die

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
