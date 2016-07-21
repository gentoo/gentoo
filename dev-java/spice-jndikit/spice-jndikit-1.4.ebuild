# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN##*-}"

DESCRIPTION="JNDI Kit is a toolkit designed to help with the construction of JNDI providers"
HOMEPAGE="https://github.com/realityforge/jndikit"
SRC_URI="https://github.com/realityforge/${MY_PN}/archive/${PV}.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_PN}-${PV}"

JAVA_SRC_DIR="src"

java_prepare() {
	rm -rf src/test || die
}

src_compile() {
	java-pkg-simple_src_compile
	pushd target/classes > /dev/null || die
	rmic org.realityforge.spice.jndikit.rmi.server.RMINamingProviderImpl \
		|| die "rmic failed"
	popd > /dev/null || die
}
