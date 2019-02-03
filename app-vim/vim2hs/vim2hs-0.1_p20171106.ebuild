# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin vcs-snapshot

# Commit Date: 16 Apr 2014
COMMIT="f2afd55704bfe0a2d66e6b270d247e9b8a7b1664"

DESCRIPTION="vim plugin: collection of vimscripts for Haskell development"
HOMEPAGE="https://github.com/dag/vim2hs"
SRC_URI="https://github.com/dag/vim2hs/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/ghc"

src_compile() { :; }

src_install() {
	# We want a stripped-down version of these.
	local f
	for f in screenshots/*; do
		bzip2 -9 "${f}" || die
	done
	vim-plugin_src_install
}
