# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby implementation of JSDeferred"
HOMEPAGE="https://github.com/toshia/delayer-deferred"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/delayer:1"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/helper.rb || die
	sed -i -e '/simplecov/,/^end/ s:^:#:' test/helper.rb || die
	sed -i -e '/pry/ s:^:#:' test/sleep_test.rb || die
}
