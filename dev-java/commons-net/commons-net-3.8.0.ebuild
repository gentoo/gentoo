# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

MY_P="${P}-sources"

DESCRIPTION="Client-oriented Java library to implement many Internet protocols"
HOMEPAGE="https://commons.apache.org/net/"
SRC_URI="https://repo1.maven.org/maven2/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
