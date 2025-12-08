# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Provides Haml generators for Rails 4"
HOMEPAGE="https://github.com/haml/haml-rails"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/actionpack-5.1:*
	>=dev-ruby/activesupport-5.1:*
	>=dev-ruby/railties-5.1:*
	>=dev-ruby/haml-4.0.6:*
"

ruby_add_bdepend "test? ( >=dev-ruby/rails-5.1 )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile test/test_helper.rb || die
	sed -i -e 's/MiniTest/Minitest/' test/test_helper.rb || die
}
