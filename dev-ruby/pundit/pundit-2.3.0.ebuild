# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Object oriented authorization for Rails applications"
HOMEPAGE="https://github.com/varvet/pundit https://rubygems.org/gems/pundit"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-3.0.0:*"

ruby_add_bdepend "test? (
	>=dev-ruby/actionpack-3.0.0
	>=dev-ruby/activemodel-3.0.0
	>=dev-ruby/railties-3.0.0
)"

all_ruby_prepare() {
	sed -i -e "/pry/d" -e '/simplecov/,/^end/ s:^:#:' -e '2igem "rack", "~> 2.0"' spec/spec_helper.rb || die
}
