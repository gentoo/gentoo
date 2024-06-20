# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit texlive-common

TL_VERSION="$(ver_cut 1)$(ver_cut 2)$(ver_cut 3)"
DESCRIPTION="DVI-to-PostScript translator"
HOMEPAGE="https://tug.org/texlive/"
SRC_URI="https://mirrors.ctan.org/systems/texlive/Source/texlive-${TL_VERSION}-source.tar.xz"

DVIPS_REVISION=$(ver_cut 5)
EXTRA_TL_MODULES="dvips.r${DVIPS_REVISION}"
EXTRA_TL_DOC_MODULES="dvips.doc.r${DVIPS_REVISION}"

texlive-common_append_to_src_uri EXTRA_TL_MODULES

SRC_URI+=" doc? ( "
texlive-common_append_to_src_uri EXTRA_TL_DOC_MODULES
SRC_URI+=" ) "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc source"

DEPEND=">=dev-libs/kpathsea-6.2.1:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/texlive-${TL_VERSION}-source/texk/${PN}"

src_configure() {
	econf --with-system-kpathsea
}

src_install() {
	emake DESTDIR="${D}" prologdir="${EPREFIX}/usr/share/texmf-dist/dvips/base" install

	dodir /usr/share # just in case
	cp -pR "${WORKDIR}"/texmf-dist "${ED}/usr/share/" || die "failed to install texmf trees"
	if use source ; then
		cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	etexmf-update
}

pkg_postrm() {
	etexmf-update
}
