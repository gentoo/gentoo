# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"
RUBY_FAKEGEM_GEMSPEC="sequel.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem

DESCRIPTION="A lightweight database toolkit for Ruby"
HOMEPAGE="https://sequel.jeremyevans.net/"
SRC_URI="https://github.com/jeremyevans/sequel/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "dev-ruby/bigdecimal"

ruby_add_bdepend "test? (
	dev-ruby/activemodel
	dev-ruby/minitest
	dev-ruby/minitest-global_expectations
	dev-ruby/minitest-hooks
	dev-ruby/nokogiri
	dev-ruby/tzinfo
)"
