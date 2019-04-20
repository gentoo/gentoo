# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_NAME="neovim"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby bindings for Neovim"
HOMEPAGE="https://github.com/alexgenco/neovim-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend ">=dev-ruby/msgpack-1.0.0"
ruby_add_rdepend ">=dev-ruby/multi_json-1.0.0"
