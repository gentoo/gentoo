# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="https://asm.ow2.io"
MY_P="ASM_${PV//./_}"
SRC_URI="https://gitlab.ow2.org/asm/asm/-/archive/${MY_P}/asm-${MY_P}.tar.gz https://gitlab.ow2.org/asm/asm/-/archive/ASM_4_0/asm-ASM_4_0.tar.gz"

LICENSE="BSD"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"

CDEPEND=""
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/asm-${MY_P}"

# Needs dependencies we don't have yet.
RESTRICT="test"

EANT_DOC_TARGET="jdoc"

# Fails if this objectweb.ant.tasks.path is not set.
# Java generics seem to break unless product.noshrink is set.
EANT_EXTRA_ARGS="-Dobjectweb.ant.tasks.path=foobar -Dproduct.noshrink=true"

src_prepare() {
	default
	# Borrow some ant scripts from an old version to avoid requiring
	# bndlib and friends. This may not work forever!
	cp -vf "../asm-ASM_4_0/archive"/*.xml archive/ || die
}

src_install() {
	for x in output/dist/lib/*.jar ; do
		java-pkg_newjar "${x}" $(basename "${x%-*}.jar")
	done

	use doc && java-pkg_dojavadoc output/dist/doc/javadoc/user/
	use source && java-pkg_dosrc src/*
}
