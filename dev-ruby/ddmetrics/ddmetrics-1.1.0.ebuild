# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Non-timeseries measurements for Ruby programs"
HOMEPAGE="https://github.com/denisdefreyne/ddmetrics/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~riscv"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/rspec-its dev-ruby/timecop )"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' \
		-e '/fuubar/ s:^:#:' \
		-e '/RSpec.configure/,/end/ s:^:#:' spec/spec_helper.rb || die
}
