# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="8-bit Implementation of BibTeX 0.99 with a Very Large Capacity"
HOMEPAGE="https://tug.org/texlive/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/texlive/texlive-${PV#*_p}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="doc source"

RDEPEND=">=dev-libs/kpathsea-6.2.1:=
	>=dev-libs/icu-4.4:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/bibtex-x

TL_VERSION=2021
EXTRA_TL_MODULES="bibtex8 bibtexu"
EXTRA_TL_DOC_MODULES="bibtex8.doc bibtexu.doc"

for i in ${EXTRA_TL_MODULES} ; do
	SRC_URI="${SRC_URI} https://dev.gentoo.org/~sam/distfiles/texlive/tl-${i}-${TL_VERSION}.tar.xz"
done

SRC_URI="${SRC_URI} doc? ( "
for i in ${EXTRA_TL_DOC_MODULES} ; do
	SRC_URI="${SRC_URI} https://dev.gentoo.org/~sam/distfiles/texlive/tl-${i}-${TL_VERSION}.tar.xz"
done
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
	dodoc 00readme.txt ChangeLog csfile.txt HISTORY

	dodir /usr/share # just in case
	cp -pR "${WORKDIR}"/texmf-dist "${ED}/usr/share/" || die "failed to install texmf trees"
	if use source ; then
		cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"
	fi
}
