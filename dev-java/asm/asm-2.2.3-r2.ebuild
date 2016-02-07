# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="http://asm.objectweb.org"
SRC_URI="http://download.forge.objectweb.org/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="2.2"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc source"

CDEPEND="dev-java/ant-core:0
	dev-java/ant-owanttask:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	source? ( app-arch/zip )
	>=virtual/jdk-1.6"

PATCHES=(
	"${FILESDIR}/${P}-build.xml.patch"
	"${FILESDIR}/${P}-commons.patch"
)

JAVA_ANT_ENCODING="ISO-8859-1"
EANT_DOC_TARGET="jdoc"

# Needs unpackaged deps.
# https://bugs.gentoo.org/show_bug.cgi?id=212860
RESTRICT="test"

java_prepare() {
	epatch "${PATCHES[@]}"
	echo "objectweb.ant.tasks.path = $(java-pkg_getjar --build-only ant-owanttask ow_util_ant_tasks.jar)" >> build.properties || die
}

src_install() {
	for x in output/dist/lib/*.jar ; do
		java-pkg_newjar ${x} $(basename ${x/-${PV}})
	done
	use doc && java-pkg_dohtml -r output/dist/doc/javadoc/user/*
	use source && java-pkg_dosrc src/*
}
