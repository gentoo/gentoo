# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# tests not enabled because of missing eclass support of junit-jupiter
JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES="
	org.ow2.asm:asm-bom:${PV}
	org.ow2.asm:asm:${PV}
	org.ow2.asm:asm-analysis:${PV}
	org.ow2.asm:asm-commons:${PV}
	org.ow2.asm:asm-tree:${PV}
	org.ow2.asm:asm-util:${PV}
"

# Avoid circular dependency
JAVA_DISABLE_DEPEND_ON_JAVA_DEP_CHECK="true"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="https://asm.ow2.io"
MY_P="ASM_${PV//./_}"
SRC_URI="https://gitlab.ow2.org/asm/asm/-/archive/${MY_P}/asm-${MY_P}.tar.bz2"
S="${WORKDIR}/asm-${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x64-macos"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

ASM_MODULES=( "asm" "asm-tree" "asm-analysis" "asm-commons" "asm-util" )
JAVADOC_SRC_DIRS=(
	asm/src/main/java
	asm-tree/src/main/java
	asm-analysis/src/main/java
	asm-commons/src/main/java
	asm-util/src/main/java
)

src_prepare() {
	default
	local module
	touch asm.module || die
	for module in "${ASM_MODULES[@]}"; do
		module=${module/-/.}
		cat > ${module/./-}/src/main/java/module-info.java <<-EOF || die
			open module org.objectweb.${module/analysis/tree.analysis} {
				$(cat asm.module)
				requires java.base;
				exports org.objectweb.${module/analysis/tree.analysis};
			}
		EOF
		echo "requires transitive org.objectweb.${module/analysis/tree.analysis};" \
			>> asm.module || die
	done
	sed -e '/^$/d' \
		-e '/asm;/p;s:\(asm\)\(;\):\1.signature\2:' \
		-i  asm/src/main/java/module-info.java || die
	sed -e '/analysis/d' \
		-i  asm-commons/src/main/java/module-info.java || die
	sed -e '/commons/d' \
		-i  asm-util/src/main/java/module-info.java || die
}

src_compile() {
	local module
	for module in "${ASM_MODULES[@]}"; do
		einfo "Compiling ${module}"
		JAVA_JAR_FILENAME="${module}.jar"
		JAVA_SRC_DIR="${module}/src/main/java"
		java-pkg-simple_src_compile
		JAVA_GENTOO_CLASSPATH_EXTRA+=":${module}.jar"
		rm -r target || die
	done

	if use doc; then
		einfo "Compiling javadocs"
		for module in "${ASM_MODULES[@]}"; do
			rm "${module}/src/main/java/module-info.java" || die
			JAVA_SRC_DIR+=("${module}/src/main/java")
		done
		ejavadoc
	fi
}

src_install() {
	JAVA_JAR_FILENAME="asm.jar"
	java-pkg-simple_src_install
	local module
	for module in asm-{analysis,commons,tree,util}; do
		java-pkg_dojar ${module}.jar
		if use source; then
			java-pkg_dosrc "${module}/src/main/java/*"
		fi
	done
}
