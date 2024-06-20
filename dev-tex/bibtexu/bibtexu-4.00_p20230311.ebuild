# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit texlive-common

DESCRIPTION="8-bit Implementation of BibTeX 0.99 with a Very Large Capacity"
HOMEPAGE="https://tug.org/texlive/"
SRC_URI="https://mirrors.ctan.org/systems/texlive/Source/texlive-${PV#*_p}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc source"

RDEPEND="
	>=dev-libs/kpathsea-6.2.1:=
	>=dev-libs/icu-4.4:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/bibtex-x

TL_REVISION=66186
EXTRA_TL_MODULES="bibtex8.r${TL_REVISION} bibtexu.r${TL_REVISION}"
EXTRA_TL_DOC_MODULES="bibtex8.doc.r${TL_REVISION} bibtexu.doc.r${TL_REVISION}"

texlive-common_append_to_src_uri EXTRA_TL_MODULES

SRC_URI="${SRC_URI} doc? ( "
texlive-common_append_to_src_uri EXTRA_TL_DOC_MODULES
SRC_URI="${SRC_URI} ) "

src_configure() {
	econf \
		--with-system-kpathsea \
		--with-system-icu
}

src_install() {
	emake \
		DESTDIR="${D}" \
		csfdir="${EPREFIX}/usr/share/texmf-dist/bibtexu/csf/base" \
		btdocdir="${EPREFIX}/usr/share/doc/${PF}" \
		install
	dodoc 00bibtex8-readme.txt 00bibtex8-history.txt ChangeLog csf/csfile.txt

	dodir /usr/share # just in case
	cp -pR "${WORKDIR}"/texmf-dist "${ED}/usr/share/" || die "failed to install texmf trees"
	if use source ; then
		cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"
	fi
}
