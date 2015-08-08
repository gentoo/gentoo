# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE=""

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="KouChat is a simple serverless chat client for local area networks"
HOMEPAGE="http://kouchat.googlecode.com/"
SRC_URI="http://kouchat.googlecode.com/files/${P}-src.tar.gz
	http://dev.gentoo.org/~serkan/distfiles/${P}-buildfiles.tar.gz"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S=${WORKDIR}/${P}-src

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar
	java-pkg_dolauncher ${PN} --main net.usikkert.kouchat.KouChat
	java-pkg_dolauncher ${PN}-console --main net.usikkert.kouchat.KouChat --pkg_args "--console"
	newicon kou_shortcut.png ${PN}.png
	make_desktop_entry ${PN} "KouChat"
}
