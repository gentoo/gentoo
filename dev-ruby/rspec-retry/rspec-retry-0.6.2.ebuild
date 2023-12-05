# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="changelog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Retry randomly failing rspec example"
HOMEPAGE="https://github.com/NoRedInk/rspec-retry"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rspec-core-3.3"

all_ruby_prepare() {
	sed -i -e '/pry/ s:^:#:' spec/spec_helper.rb || die

	# Avoid specs accessing class variables from the top level
	sed -e '/with :retry => 0/ s/context/xcontext/' \
		-e '/should be exposed/ s/it/xit/' \
		-i spec/lib/rspec/retry_spec.rb || die
}
