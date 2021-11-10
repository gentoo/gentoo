# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN%-annotations}"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java annotations for marking methods that Animal Sniffer should ignore"
HOMEPAGE="http://www.mojohaus.org/animal-sniffer/animal-sniffer-annotations/"
SRC_URI="https://github.com/mojohaus/${MY_PN}/archive/${MY_PN}-parent-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${MY_PN}-${MY_PN}-parent-${PV}/${PN}"
JAVA_SRC_DIR="src/main/java"
