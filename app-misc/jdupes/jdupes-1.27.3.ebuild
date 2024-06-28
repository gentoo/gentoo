# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Identify duplicate files on the filesystem"
HOMEPAGE="https://codeberg.org/jbruchon/jdupes"
if [[ "${PV}" == *9999 ]] ; then
	EGIT_REPO_URI="https://codeberg.org/jbruchon/jdupes.git"
	inherit git-r3
else
	SRC_URI="https://codeberg.org/jbruchon/jdupes/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}
	KEYWORDS="amd64 ~arm64"
fi
LICENSE="MIT"
SLOT="0"

# Please keep a careful eye on the minimum libjoycode version! (Just pick
# latest released at the time if necessary.)
DEPEND=">=dev-libs/libjodycode-3.0"
RDEPEND="${DEPEND}"

IUSE="+dedupe hardened"

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
		$(usex hardened 'HARDEN=1' '')
	)
	emake ${myconf[@]}
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	einstalldocs
}
