# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Generates META-INF/services files automatically"
HOMEPAGE="http://metainf-services.kohsuke.org/"
SRC_URI="https://github.com/kohsuke/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/${PN}-${P}"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

src_install() {
	java-pkg_newjar target/${P}.jar
}
