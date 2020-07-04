# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST="TRAVIS=true test"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Create JSON structures via a Builder-style DSL"
HOMEPAGE="https://github.com/rails/jbuilder"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-5.0.0:*"

ruby_add_bdepend "test? (
	>=dev-ruby/railties-5.0.0
)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/test_helper.rb || die
}
