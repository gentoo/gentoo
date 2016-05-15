# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

At="${PN%-bin}-2_1_1e-alljava.zip"
S="${WORKDIR}/JMF-${PV}"
DESCRIPTION="The Java Media Framework API (JMF)"
SRC_URI="${At}"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/tech/index-jsp-140239.html"
KEYWORDS="amd64 x86"
IUSE=""
LICENSE="sun-bcla-jmf"
SLOT="0"
DEPEND=">=app-arch/unzip-5.50-r1"
RDEPEND=">=virtual/jre-1.4"
RESTRICT="fetch"
DOWNLOAD_URL="http://www.oracle.com/technetwork/java/javase/download-142937.html"

pkg_nofetch() {
	elog
	elog " Due to license restrictions, we cannot fetch the"
	elog " distributables automatically."
	elog
	elog " 1. Visit ${DOWNLOAD_URL} and select 'Linux'"
	elog " 2. Download ${At}"
	elog " 3. Move file to ${DISTDIR}"
	elog " 4. Run emerge on this package again to complete"
	elog
}

src_unpack() {
	unzip -qq "${DISTDIR}"/${At} || die
}

src_install() {
	dobin \
		"${FILESDIR}"/jmfcustomizer \
		"${FILESDIR}"/jmfinit \
		"${FILESDIR}"/jmfregistry \
		"${FILESDIR}"/jmstudio
	dohtml "${S}"/doc/*.html
	java-pkg_dojar "${S}"/lib/*.jar
	insinto /usr/share/${PN}/lib
	doins lib/jmf.properties
}
