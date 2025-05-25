# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.json:jakarta.json-api:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta JSON Processing API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jsonp"
SRC_URI="https://github.com/jakartaee/jsonp-api/archive/${PV}-RELEASE.tar.gz -> ${P}-RELEASE.tar.gz"
S="${WORKDIR}/${P}-RELEASE"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="amd64"

DEPEND=">=virtual/jdk-1.9:*"	# module-info
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="api/src/main/java"
