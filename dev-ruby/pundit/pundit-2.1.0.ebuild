# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Object oriented authorization for Rails applications"
HOMEPAGE="https://github.com/elabs/pundit https://rubygems.org/gems/pundit"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-3.0.0:*"

ruby_add_bdepend "test? ( >=dev-ruby/actionpack-3.0.0
	>=dev-ruby/activemodel-3.0.0 )"

all_ruby_prepare() {
	sed -i -e "/pry/d" spec/spec_helper.rb || die
}
