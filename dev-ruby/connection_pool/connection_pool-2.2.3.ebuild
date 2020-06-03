# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changes.md README.md"

inherit ruby-fakegem

DESCRIPTION="Generic connection pooling for Ruby"
HOMEPAGE="https://github.com/mperham/connection_pool"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5 )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' connection_pool.gemspec || die
	sed -i -e '/\(bundler\|standard\)/ s:^:#:' Rakefile || die
	sed -i -e "s/gem 'minitest'/gem 'minitest', '~> 5.0'/" test/helper.rb || die
}
