# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST="TRAVIS=true test"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Create JSON structures via a Builder-style DSL"
HOMEPAGE="https://github.com/rails/jbuilder"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-4.2.0:*"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/test_helper.rb || die
}
