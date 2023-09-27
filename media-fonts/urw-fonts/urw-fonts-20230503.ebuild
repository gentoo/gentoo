# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit font

DESCRIPTION="(URW)++ base 35 font set"
HOMEPAGE="https://github.com/ArtifexSoftware/urw-base35-fonts"
COMMIT="3c0ba3b5687632dfc66526544a4e811fe0ec0cd9"
SRC_URI="https://github.com/ArtifexSoftware/urw-base35-fonts/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

S="${WORKDIR}/urw-base35-fonts-${COMMIT}"

FONT_S="${S}/fonts"
FONT_SUFFIX="afm otf ttf"
FONT_PRIORITY="61" # Same as in Fedora
FONT_CONF=(
	fontconfig/${FONT_PRIORITY}-urw-bookman.conf
	fontconfig/${FONT_PRIORITY}-urw-c059.conf
	fontconfig/${FONT_PRIORITY}-urw-d050000l.conf
	fontconfig/${FONT_PRIORITY}-urw-fallback-backwards.conf
	fontconfig/${FONT_PRIORITY}-urw-fallback-generics.conf
	fontconfig/${FONT_PRIORITY}-urw-fallback-specifics.conf
	fontconfig/${FONT_PRIORITY}-urw-gothic.conf
	fontconfig/${FONT_PRIORITY}-urw-nimbus-mono-ps.conf
	fontconfig/${FONT_PRIORITY}-urw-nimbus-roman.conf
	fontconfig/${FONT_PRIORITY}-urw-nimbus-sans-narrow.conf
	fontconfig/${FONT_PRIORITY}-urw-nimbus-sans.conf
	fontconfig/${FONT_PRIORITY}-urw-p052.conf
	fontconfig/${FONT_PRIORITY}-urw-standard-symbols-ps.conf
	fontconfig/${FONT_PRIORITY}-urw-z003.conf
)

src_prepare() {
	default
	cd "${S}"/fontconfig
	for f in *.conf ; do
		mv "${f}" "${FONT_PRIORITY}-${f}"
	done
}

src_install() {
	font_src_install
	insinto /usr/share/metainfo
	doins appstream/*.xml
}
