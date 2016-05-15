# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

MY_P="hawtjni-project-${PV}"

DESCRIPTION="Maven plugin for the HawtJNI code generator (resources only)"
HOMEPAGE="https://github.com/fusesource/hawtjni"
SRC_URI="https://github.com/fusesource/hawtjni/archive/${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/hawtjni-${MY_P}/${PN}"

src_compile() {
	touch ${PN}.jar || die # jar won't create on update.
	java-pkg_addres ${PN}.jar src/main/resources
}

src_install() {
	java-pkg_dojar ${PN}.jar
}
