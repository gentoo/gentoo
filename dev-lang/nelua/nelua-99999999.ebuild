# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Statically-typed systems programming language inspired by Lua"
HOMEPAGE="https://nelua.io/
	https://github.com/edubart/nelua-lang/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/edubart/nelua-lang.git"
else
	SRC_URI="https://github.com/edubart/nelua-lang/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/nelua-lang-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-lua/luacheck
	)
"

DOCS=( CONTRIBUTING.md README.md )

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	einstalldocs
}
