# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="relaxngDatatype:relaxngDatatype:20020414"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Interface between RELAX NG validators and datatype libraries"
HOMEPAGE="https://relaxng.org/"
SRC_URI="https://repo1.maven.org/maven2/relaxngDatatype/relaxngDatatype/${PV}/relaxngDatatype-${PV}-sources.jar"

KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"
LICENSE="BSD"
SLOT="0"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"
