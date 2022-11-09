# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-collection_matchers"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rspec-expectations-3.0.0"

ruby_add_bdepend "test? ( >=dev-ruby/activemodel-3.0 )"
