# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin vcs-snapshot

COMMIT="c67bdfcdb31415aa0ade7f8c003261700a885476"

DESCRIPTION="vim plugin: molokai color scheme"

HOMEPAGE="https://github.com/tomasr/molokai"
SRC_URI="https://github.com/tomasr/molokai/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="vim"
KEYWORDS="amd64 x86"
