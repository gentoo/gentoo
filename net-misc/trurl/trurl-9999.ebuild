# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Command line tool for URL parsing and manipulation"
HOMEPAGE="https://daniel.haxx.se/blog/2023/04/03/introducing-trurl/ https://github.com/curl/trurl"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/curl/trurl"
	inherit git-r3
else
	SRC_URI="https://github.com/curl/trurl/archive/refs/tags/${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${P}

	KEYWORDS="~amd64"
fi

LICENSE="curl"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=net-misc/curl-7.62.0"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-lang/perl )"

src_compile() {
	tc-export CC

	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
}
