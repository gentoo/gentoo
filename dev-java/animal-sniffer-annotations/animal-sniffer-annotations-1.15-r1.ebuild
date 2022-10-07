# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-annotations}"
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.codehaus.mojo:animal-sniffer-annotations:1.15"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java annotations for marking methods that Animal Sniffer should ignore"
HOMEPAGE="http://www.mojohaus.org/animal-sniffer/animal-sniffer-annotations/"
SRC_URI="https://github.com/mojohaus/${MY_PN}/archive/${MY_PN}-parent-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${MY_PN}-${MY_PN}-parent-${PV}/${PN}"
JAVA_SRC_DIR="src/main/java"
