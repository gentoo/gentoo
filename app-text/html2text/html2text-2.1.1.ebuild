# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/grobian/html2text.git"
else
	SRC_URI="https://github.com/grobian/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="HTML to text converter"
HOMEPAGE="https://github.com/grobian/html2text"

LICENSE="GPL-2"
SLOT="0"

src_configure() {
	# non-autoconf configure
	tc-export CXX
	default
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
