# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

COMMIT_HASH="824dcfe76568dba38135332fc4729e2b2c4d9b3a"

DESCRIPTION="vim plugin: Filetype plugin for dev-lang/jsonnet"
HOMEPAGE="https://github.com/google/vim-jsonnet"
SRC_URI="https://github.com/google/vim-jsonnet/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/jsonnet"

S="${WORKDIR}/${PN}-${COMMIT_HASH}"

src_prepare() {
	default

	rm -f LICENSE .gitignore || die
}
