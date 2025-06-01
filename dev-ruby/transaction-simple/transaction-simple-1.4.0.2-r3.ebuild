# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Provides transaction support at the object level"
HOMEPAGE="https://github.com/halostatue-archive/transaction-simple"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/test-unit-2.5.1-r1
	)"

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test_*.rb
}
