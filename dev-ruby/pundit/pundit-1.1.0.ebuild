# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="doc"

inherit ruby-fakegem

DESCRIPTION="Object oriented authorization for Rails applications"
HOMEPAGE="https://github.com/elabs/pundit https://rubygems.org/gems/pundit"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-3.0.0"

ruby_add_bdepend "test? ( >=dev-ruby/actionpack-3.0.0
	>=dev-ruby/activemodel-3.0.0 )"

all_ruby_prepare() {
	sed -i -e "/pry/d" spec/spec_helper.rb || die
}
