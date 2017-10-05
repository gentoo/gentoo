# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2

DESCRIPTION="A utility that converts ascii-art diagrams to bitmap diagrams"
HOMEPAGE="https://github.com/stathissideris/ditaa"
SRC_URI="https://github.com/stathissideris/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-java/ant-core:0
	>=virtual/jdk-1.7:*"
RDEPEND=">=virtual/jdk-1.7:*"

src_prepare() {
	default
	sed "s:0_9:${PV/./_}:" -i build/release.xml || die
	sed "s:version 0.9:version ${PV}:" -i \
		src/org/stathissideris/ascii2image/core/CommandLineConverter.java || die
}

src_compile() {
	mkdir bin || die
	ant -buildfile build/release.xml release-jar || die
}

src_install() {
	java-pkg_newjar releases/${PN}${PV/./_}.jar ${PN}.jar
	java-pkg_dolauncher ${PN}
}
