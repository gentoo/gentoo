# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/grobian/html2text.git"
else
	SRC_URI=""
	KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
fi

DESCRIPTION="HTML to text converter"
HOMEPAGE="https://github.com/grobian/html2text"

LICENSE="GPL-2"
SLOT="0"

src_prepare() {
	default
	tc-export CXX
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		MANDIR="${EPREFIX}/usr/share/man" \
		DOCDIR="${EPREFIX}/usr/share/doc/${P}" \
		install
}
