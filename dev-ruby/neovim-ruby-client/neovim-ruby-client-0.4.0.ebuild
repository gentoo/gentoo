# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_NAME="neovim"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby bindings for Neovim"
HOMEPAGE="https://github.com/alexgenco/neovim-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend ">=dev-ruby/msgpack-1.0.0"
