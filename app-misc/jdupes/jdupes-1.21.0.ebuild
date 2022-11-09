# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Identify duplicate files on the filesystem"
HOMEPAGE="https://github.com/jbruchon/jdupes"
if [[ "${PV}" == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/jbruchon/jdupes.git"
	inherit git-r3
else
	SRC_URI="https://github.com/jbruchon/jdupes/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="MIT"
SLOT="0"

IUSE="+dedupe lowmem hardened"

# missing test.sh script
# https://github.com/jbruchon/jdupes/issues/191
RESTRICT="test"

src_prepare() {
	sed -i -e '/PREFIX/s/=/?=/' Makefile || die
	default
}

src_compile() {
	tc-export CC
	local myconf=(
		$(usex dedupe 'ENABLE_DEDUPE=1' '')
		$(usex lowmem 'LOW_MEMORY=1' '')
		$(usex hardened 'HARDEN=1' '')
	)
	emake ${myconf[@]}
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	einstalldocs
}
