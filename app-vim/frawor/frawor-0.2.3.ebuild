# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: modular vim framework"
HOMEPAGE="https://bitbucket.org/ZyX_I/frawor"
SRC_URI="https://bitbucket.org/ZyX_I/${PN}/downloads/${P}.tar.xz"

LICENSE="vim"
KEYWORDS="amd64 x86"

# Tests rely on zsh. No.
RESTRICT="test"
