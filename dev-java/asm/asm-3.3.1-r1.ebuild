# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_ANT_TASKS="ant-owanttask"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="http://asm.objectweb.org"
SRC_URI="http://download.forge.objectweb.org/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="3"
IUSE=""
KEYWORDS="amd64 ppc64 x86 ~amd64-fbsd ~x86-fbsd ~sparc-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

# Needs deps we don't have yet
RESTRICT="test"

EANT_DOC_TARGET="jdoc"

# Fails if this property is not set
EANT_EXTRA_ARGS="-Dobjectweb.ant.tasks.path=foobar"

src_install() {
	for x in output/dist/lib/*.jar ; do
		java-pkg_newjar ${x} $(basename ${x/-${PV}})
	done
	use doc && java-pkg_dojavadoc output/dist/doc/javadoc/user/
	use source && java-pkg_dosrc src/*
}
