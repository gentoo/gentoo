# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

COMMIT_HASH="95593b67723f23979cd7344ecfd049f2f917830f"
DESCRIPTION="Vim plugin for clang-format"
HOMEPAGE="https://github.com/rhysd/vim-clang-format"
SRC_URI="https://github.com/rhysd/${PN}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-devel/clang"

src_prepare() {
	default

	# tests are written in ruby, prefer to avoid that
	rm -r .travis.yml test || die
}
