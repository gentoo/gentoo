# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 wrapper

DESCRIPTION="Statically typed language that targets the JVM and JavaScript"
HOMEPAGE="https://kotlinlang.org/
	https://github.com/JetBrains/kotlin/"
SRC_URI="https://github.com/JetBrains/kotlin/releases/download/v${PV}/kotlin-compiler-${PV}.zip"
S="${WORKDIR}/kotlinc"

LICENSE="Apache-2.0 BSD MIT NPL-1.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.8:*
"
DEPEND="
	>=virtual/jdk-1.8:*
"
BDEPEND="
	app-arch/unzip
"

src_prepare() {
	default

	rm bin/*.bat || die
}

src_compile() {
	:
}

src_install() {
	java-pkg_dojar lib/*

	# Follow the Java eclass JAR installation path.
	local app_home="/usr/share/${PN}"

	exeinto "${app_home}/bin"
	doexe bin/*

	local -a exes=(
		kapt
		kotlin
		kotlinc
		kotlinc-js
		kotlinc-jvm
		kotlin-dce-js
	)
	local exe
	for exe in "${exes[@]}" ; do
		make_wrapper "${exe}" "${app_home}/bin/${exe}"
	done
}
