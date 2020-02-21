# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Remote Desktop (jrdesktop) for viewing and/or controlling a distance PC"
HOMEPAGE="http://jrdesktop.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${PN}"

EANT_EXTRA_ARGS="-Djnlp.enabled=false"

src_install() {
	java-pkg_dojar "dist/${PN}.jar"

	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc dist/javadoc

	java-pkg_dolauncher
}
