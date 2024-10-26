# Copyright 1999-2024 Gentoo Authors
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

COMMON_DEP="
	virtual/jdk:1.8
	>=media-sound/pulseaudio-0.9.11"
RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}"
BDEPEND="app-arch/zip"

pkg_setup() {
	JAVA_PKG_WANT_SOURCE="1.8"
	JAVA_PKG_WANT_TARGET="1.8"

	java-pkg-2_pkg_setup
}

src_configure() {
	econf --with-jdk-home="${JAVA_HOME}" \
		$(use_enable doc docs) \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
}

src_compile() {
	default
}
