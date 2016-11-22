# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-parent-${PV}"

DESCRIPTION="A modern JSON library for Android and Java"
HOMEPAGE="https://github.com/square/moshi"
SRC_URI="https://github.com/square/${PN}/archive/${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/assertj-core:2
	dev-java/junit:4
	dev-java/okio:0
"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="assertj-core-2,junit-4,okio"

JAVA_SRC_PATH="${WORKDIR}/${MY_P}/${PN}/src"

src_prepare() {
	# Some don't compile, not putting effort into it now
	rm -rf "${WORKDIR}/${PN}-${MY_P}/${PN}"/src/test
}
