# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.mozilla:rhino:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Rhino JavaScript runtime jar, excludes XML, tools, and ScriptEngine wrapper"
HOMEPAGE="https://github.com/mozilla/rhino"
SRC_URI="https://github.com/mozilla/rhino/archive/Rhino${PV//./_}_Release.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rhino-Rhino${PV//./_}_Release"

LICENSE="MPL-1.1 GPL-2"
KEYWORDS="~amd64 ~arm64 ~ppc64"
SLOT="0"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-11:*"

DOCS=( {CODE_OF_CONDUCT,README,RELEASE-NOTES,RELEASE-STEPS}.md {NOTICE-tools,NOTICE}.txt )

JAVA_RESOURCE_DIRS="rhino/src/main/resources"
JAVA_SRC_DIR="rhino/src/main/java"
