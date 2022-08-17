# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID=""

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A JNI code generator based on the generator used by the Eclipse SWT project"
HOMEPAGE="https://github.com/fusesource/hawtjni"
SRC_URI="https://github.com/fusesource/hawtjni/archive/hawtjni-project-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {changelog,notice,readme}.md )

S="${WORKDIR}/hawtjni-hawtjni-project-${PV}"

JAVA_AUTOMATIC_MODULE_NAME="org.fusesource.hawtjni.runtime"
JAVA_SRC_DIR="${PN}/src/main/java"
