# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bfm/bfm-1.2-r2.ebuild,v 1.3 2013/08/28 11:14:24 ago Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="File manager and first person shooter written in Java3D, you remove files by shooting at them"
HOMEPAGE="http://bfm.webhop.net"
SRC_URI="http://bfm.webhop.net/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/sun-java3d-bin:0"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

java_prepare() {
	cp "${FILESDIR}"/${PVR}-build.xml ./build.xml || die

	mkdir lib || die
	pushd lib
		java-pkg_jar-from sun-java3d-bin
	popd

	epatch "${FILESDIR}"/${PVR}-package.patch

	mkdir -p net/webhop/bfm || die
	mv src/* net/webhop/bfm/ || die
}

EANT_DOC_TARGET="docs"

src_install() {
	local java3d="sun-java3d-bin"

	java-pkg_dojar dist/${PN}.jar
	java-pkg_dolauncher ${PN} --main net.webhop.bfm.Bfm

	insinto /etc/bfm
	doins "${S}/bfm.conf"

	if use doc; then
		dodoc README ChangeLog bindings NEWS
		java-pkg_dohtml -r docs/*
	fi

	use source && java-pkg_dosrc src/*
}

pkg_postinst() {
	elog "A system wide config file has been installed to /etc/bfm/bfm.conf"
	elog "Copy the file to ~/.bfm/bfm.conf to set local settings"
	echo
	ewarn "Be sure to run bfm in safe mode if you don't want to delete files"
}
