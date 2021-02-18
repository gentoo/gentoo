# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Kotlin is a multiplatform, statically typed programming language by JetBrains"
HOMEPAGE="https://kotlinlang.org"
SRC_URI="https://github.com/JetBrains/kotlin/releases/download/v${PV}/kotlin-compiler-${PV}.zip"

LICENSE="Apache-2.0 BSD MIT NPL-1.1 Boost-1.0 EPL-1.0 LGPL-2.1"
SLOT="1.4"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND=""
S="${WORKDIR}/kotlinc"

src_prepare() {
	default
	rm -f bin/*.bat || die 'failed to clean .bat files'
	rm -f lib/*-sources.jar || die 'failed to clean source jars'
	ebegin 'patching KOTLIN_HOME variable for kotlinc'
	sed -i -e "s#\\(KOTLIN_HOME\\)=.*#\\1=/usr/share/kotlin-bin-${SLOT}#" "bin/kotlinc" || die
	eend $?
}

src_install() {
	dobin bin/*
	java-pkg_dojar lib/*
}
