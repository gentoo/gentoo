# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="File manager and first person shooter written in Java3D, you remove files by shooting at them"
HOMEPAGE="http://bfm.webhop.net"
SRC_URI="http://bfm.webhop.net/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	>=dev-java/sun-java3d-bin-1.3"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	cp "${FILESDIR}/${PV}-build.xml" ./build.xml

	mkdir "${S}/lib" && cd "${S}/lib"
	if has_version dev-java/sun-java3d-bin; then
		java-pkg_jar-from sun-java3d-bin
	elif has_version dev-java/blackdown-java3d-bin; then
		java-pkg_jar-from blackdown-java3d-bin
	fi
}

EANT_DOC_TARGET=""

src_install() {
	java-pkg_dojar dist/${PN}.jar

	local java3d=""
	if has_version dev-java/blackdown-java3d-bin; then
		java3d="blackdown-java3d-bin"
	elif has_version dev-java/sun-java3d-bin; then
		java3d="sun-java3d-bin"
	fi

	java-pkg_dolauncher ${PN} --main Bfm

	insinto /etc/bfm
	doins "${S}/bfm.conf"

	if use doc; then
		dodoc README ChangeLog bindings NEWS || die
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
