# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST="CI=true test"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Create JSON structures via a Builder-style DSL"
HOMEPAGE="https://github.com/rails/jbuilder"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	|| ( dev-ruby/activesupport:7.1 dev-ruby/activesupport:7.0 dev-ruby/activesupport:6.1 )
	|| ( dev-ruby/actionview:7.1 dev-ruby/actionview:7.0 dev-ruby/actionview:6.1 )
"

ruby_add_bdepend "test? (
	>=dev-ruby/activemodel-5.0.0
	>=dev-ruby/railties-5.0.0
	dev-ruby/mocha:2
)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/test_helper.rb || die
}
