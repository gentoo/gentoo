# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.ow2.asm:asm-bom:9.3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="https://asm.ow2.io"
MY_P="ASM_${PV//./_}"
SRC_URI="https://gitlab.ow2.org/asm/asm/-/archive/${MY_P}/asm-${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="9"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~x64-macos"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

ASM_MODULES=( "asm" "asm-tree" "asm-analysis" "asm-commons" "asm-util" )

S="${WORKDIR}/asm-${MY_P}"

src_compile() {
	local module
	for module in "${ASM_MODULES[@]}"; do
		einfo "Compiling ${module}"
		JAVA_RESOURCE_DIRS=()
		JAVA_MAIN_CLASS=""
		JAVA_SRC_DIR="$module/src/main/java"
		JAVA_JAR_FILENAME="$module.jar"
		# Not all of the modules have resources.
		if [[ -d $module/src/main/resources ]]; then \
			JAVA_RESOURCE_DIRS="$module/src/main/resources"
		fi
		java-pkg-simple_src_compile
		JAVA_GENTOO_CLASSPATH_EXTRA+=":$module.jar"
		rm -r target || die
	done

	if use doc; then
		JAVA_SRC_DIR=()
		JAVA_JAR_FILENAME="ignoreme.jar"
		for module in "${ASM_MODULES[@]}"; do
			JAVA_SRC_DIR+=( "$module/src/main/java" )
		done
		java-pkg-simple_src_compile
	fi
}

src_install() {
	einstalldocs # https://bugs.gentoo.org/789582
	local module
	for module in "${ASM_MODULES[@]}"; do
		java-pkg_dojar $module.jar
		if use source; then
			java-pkg_dosrc "$module/src/main/java/*"
		fi
	done
	if use doc; then
		java-pkg_dojavadoc target/api
	fi
}
