# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Efficient and thread-safe code loader for Ruby"
HOMEPAGE="https://github.com/fxn/zeitwerk"
SRC_URI="https://github.com/fxn/zeitwerk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/warning )"

all_ruby_prepare() {
	rm -f Gemfile.lock || die
	# Dropping proveit should be fine based on https://github.com/fxn/zeitwerk/pull/253
	# It's more of a quality check for the tests themselves rather than a test
	sed -i -e '/\(focus\|reporters\|Reporters\|prove_\?it\)/ s:^:#:' Gemfile test/test_helper.rb || die

	sed -i -e 's:require_relative "lib:require "./lib:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rake test || die
}
