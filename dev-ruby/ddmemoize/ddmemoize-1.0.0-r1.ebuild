# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Beware: suspicious non-fatal warnings appear in tests with >=ruby31
# Needs more investigation
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Adds support for memoizing functions"
HOMEPAGE="https://github.com/ddfreyne/ddmemoize/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~riscv"
IUSE=""

ruby_add_rdepend "
	dev-ruby/ddmetrics:1
	dev-ruby/ref:2
"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^SimpleCov.formatter/ s:^:#:' \
		-e '/fuubar/,/^end/ s:^:#:' spec/spec_helper.rb || die
}
