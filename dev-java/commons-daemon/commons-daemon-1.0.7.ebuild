# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
WANT_AUTOCONF=2.5
JAVA_PKG_IUSE="doc examples source"

inherit eutils autotools java-pkg-2 java-ant-2

DESCRIPTION="Tools to allow Java programs to run as UNIX daemons"
SRC_URI="mirror://apache/commons/daemon/source/${P}-src.tar.gz"
HOMEPAGE="http://commons.apache.org/daemon/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd"
IUSE="kernel_linux"

COMMON_DEP="
	kernel_linux? ( sys-libs/libcap )"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"

S="${WORKDIR}/${P}-src"

java_prepare() {
	cd "${S}/src/native/unix" || die
	sed -i "s/powerpc/powerpc|powerpc64/g" support/apsupport.m4 || die
	eautoconf
}

src_configure() {
	java-ant-2_src_configure
	cd "${S}/src/native/unix" || die
	default
}

src_compile() {
	java-pkg-2_src_compile
	cd "${S}/src/native/unix" || die
	default
}

src_install() {
	dobin src/native/unix/jsvc
	java-pkg_newjar dist/*.jar

	dodoc README RELEASE-NOTES.txt *.html src/native/unix/CHANGES.txt
	use doc && java-pkg_dohtml -r dist/docs/*
	use examples && java-pkg_doexamples src/samples
	use source && java-pkg_dosrc src/java/* src/native/unix/native
}
