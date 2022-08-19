# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Generates META-INF/services files automatically"
HOMEPAGE="https://metainf-services.kohsuke.org/"
SRC_URI="https://github.com/kohsuke/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
