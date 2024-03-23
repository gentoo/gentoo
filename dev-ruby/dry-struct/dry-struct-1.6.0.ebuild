# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="dry-struct.gemspec"

inherit ruby-fakegem

DESCRIPTION="Typed structs and value objects"

HOMEPAGE="https://dry-rb.org/gems/dry-struct/"
SRC_URI="https://github.com/dry-rb/dry-struct/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/dry-core:1
	>=dev-ruby/dry-types-1.7:1
	>=dev-ruby/ice_nine-0.11:0
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "test? (
	dev-ruby/dry-monads
	dev-ruby/dry-struct
	dev-ruby/warning
)"

all_ruby_prepare() {
	# Avoid broken spec, already fixed upstream.
	sed -e '/with Test::User/ s/context/xcontext/' \
		-e '/with Test::SuperUSer/ s/context/xcontext/' \
		-i spec/extensions/pretty_print_spec.rb || die
}
