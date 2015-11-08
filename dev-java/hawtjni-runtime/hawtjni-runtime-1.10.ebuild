# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="hawtjni-project-${PV}"

DESCRIPTION="A JNI code generator based on the generator used by the Eclipse SWT project"
HOMEPAGE="https://github.com/fusesource/hawtjni"
SRC_URI="https://github.com/fusesource/hawtjni/archive/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ppc ppc64"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/hawtjni-${MY_P}/${PN}/src"
JAVA_SRC_DIR="main/java"

src_install() {
	java-pkg-simple_src_install
	dodoc ../../{changelog,notice,readme}.md
}
