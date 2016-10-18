# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java annotation-based framework for parsing Git like command line structures"
HOMEPAGE="https://github.com/airlift/airline/"
# Renaming to avoid conflict with app-vim/airline:
SRC_URI="https://github.com/airlift/${PN}/archive/${PV}.tar.gz -> ${CATEGORY}-${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.7
	dev-java/guava:18
	dev-java/javax-inject:0
	dev-java/jsr305:0
	dev-java/testng:0"

RDEPEND=">=virtual/jre-1.7
	${DEPEND}"

JAVA_GENTOO_CLASSPATH="guava-18,javax-inject,jsr305,testng"
