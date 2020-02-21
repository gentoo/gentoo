# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Efficient and thread-safe code loader for Ruby"
HOMEPAGE="https://github.com/fxn/zeitwerk"
SRC_URI="https://github.com/fxn/zeitwerk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bundler )"

all_ruby_prepare() {
	rm -f Gemfile.lock || die
	sed -i -e '/\(focus\|reporters\|Reporters\)/ s:^:#:' Gemfile test/test_helper.rb || die

	sed -i -e 's:require_relative "lib:require "./lib:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rake test || die
}
