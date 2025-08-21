# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Build written by Andrew John Hughes (gnu_andrew@member.fsf.org)

EAPI=8

inherit java-pkg-2

DESCRIPTION="Plugins for javax.sound"
HOMEPAGE="https://icedtea.classpath.org"
SRC_URI="https://icedtea.classpath.org/download/source/${P}.tar.xz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

IUSE="+doc"

BDEPEND="app-arch/zip"
COMMON_DEP="media-libs/libpulse"
DEPEND="
	${COMMON_DEP}
	virtual/jdk:1.8
"
RDEPEND="
	${COMMON_DEP}
	virtual/jre:1.8
"

src_configure() {
	econf --with-jdk-home="${JAVA_HOME}" \
		$(use_enable doc docs) \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
}

src_compile() {
	default
}
