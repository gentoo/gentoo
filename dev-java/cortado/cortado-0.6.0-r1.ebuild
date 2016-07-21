# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Multimedia framework for Java written by Fluendo"
HOMEPAGE="http://www.theora.org/cortado/"
SRC_URI="http://downloads.xiph.org/releases/cortado/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"

EANT_BUILD_TARGET="stripped"

src_prepare() {
	echo "#!/bin/sh" > scripts/get-revision || die
	echo "echo ${PV}" >> scripts/get-revision || die
}

src_install() {
	java-pkg_newjar "output/dist/applet/${PN}-ovt-stripped-${PV}.jar"
	dodoc ChangeLog HACKING NEWS README RELEASE TODO \
		|| die "dodoc failed"
}
