# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Multimedia framework for Java written by Fluendo"
HOMEPAGE="https://www.theora.org/cortado/"
SRC_URI="https://downloads.xiph.org/releases/cortado/${P}.tar.gz
	https://sources.debian.org/data/main/c/cortado/0.6.0-5/debian/patches/sun.audio-Java-9.patch
	-> cortado-sun.audio-Java-9.patch"
S="${WORKDIR}/${P}"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ChangeLog HACKING NEWS README RELEASE TODO )

PATCHES=( "${DISTDIR}/cortado-sun.audio-Java-9.patch" )

JAVA_SRC_DIR="src"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	cat > scripts/get-revision <<-EOF || die
		#!/bin/sh
		echo ${PV}
	EOF
}
