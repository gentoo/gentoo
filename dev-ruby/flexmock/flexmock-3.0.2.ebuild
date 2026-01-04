# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md doc/*.rdoc doc/releases/*"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="flexmock.gemspec"

inherit ruby-fakegem

DESCRIPTION="Simple mock object library for Ruby unit testing"
HOMEPAGE="https://github.com/doudou/flexmock"
SRC_URI="https://github.com/doudou/flexmock/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="flexmock"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
	)"

each_ruby_test() {
	MT_NO_PLUGINS=1 ${RUBY} -Ilib:.:test -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}

all_ruby_prepare() {
	sed -i -e '1igem "minitest", "~>5.0"' test/test_helper.rb || die

	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Account for different exception output in Ruby 3.4
	sed -e '/assert_match/ s/`does_not_exist/.does_not_exist/' \
		-i test/partial_mock_test.rb || die
}
