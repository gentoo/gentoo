# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit java-pkg-2

DESCRIPTION="Armed Bear Common Lisp is a Common Lisp implementation for the JVM"
HOMEPAGE="https://abcl.org"
SRC_URI="https://abcl.org/releases/${PV}/abcl-src-${PV}.tar.gz"
S="${WORKDIR}/abcl-src-${PV}"

LICENSE="GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64"

BDEPEND=">=dev-java/ant-1.10.15-r1:0"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

src_compile() {
	local targets=( abcl.compile abcl.jar )
	eant \
		-Dant.build.javac.source="$(java-pkg_get-source)" \
		-Dant.build.javac.target="$(java-pkg_get-target)" \
		"${targets[@]}"
}

src_install() {
	java-pkg_dojar dist/abcl.jar dist/abcl-contrib.jar
	java-pkg_dolauncher ${PN} --java_args "-server -Xrs" --main org.armedbear.lisp.Main

	einstalldocs
}
