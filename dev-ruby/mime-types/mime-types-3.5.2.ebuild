# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="History.md README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Provides a mailcap-like MIME Content-Type lookup for Ruby"
HOMEPAGE="https://github.com/mime-types/ruby-mime-types"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ppc ~ppc64 ~riscv ~s390 sparc x86"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 dev-ruby/minitest-hooks:1 )"

ruby_add_rdepend ">=dev-ruby/mime-types-data-3.2015:3"

all_ruby_prepare() {
	# Avoid unneeded developer-only dependencies.
	sed -i -e '/\(focus\|rg\)/ s:^:#:' \
		-e 's:fivemat/::' test/minitest_helper.rb || die
}

each_ruby_test() {
	MT_NO_PLUGINS=1 ${RUBY} -Ilib:test:. -e 'require "minitest/autorun"; Dir["test/test_*.rb"].each{|f| require f}' || die
}
