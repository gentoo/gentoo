# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_NAME="neovim"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINDIR="exe"

inherit ruby-fakegem

DESCRIPTION="Ruby bindings for Neovim"
HOMEPAGE="https://github.com/neovim/neovim-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND+=" app-editors/neovim"
DEPEND+=" test? ( app-editors/neovim )"

ruby_add_rdepend "
	>=dev-ruby/msgpack-1.1:0
	=dev-ruby/multi_json-1*
"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|pry\)/ s:^:#:' spec/helper.rb || die

	# Avoid tests that result in a unix socket path that is too long
	sed -e '/\(establishes an RPC connection\|sets appropriate client info\)/askip "socket path length"' \
		-i spec/neovim_spec.rb || die
}
