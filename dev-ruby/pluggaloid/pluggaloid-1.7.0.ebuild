# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem
DESCRIPTION="Pluggaloid is extensible plugin system for mikutter"
HOMEPAGE="https://rubygems.org/gems/pluggaloid/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/delayer-1.1.0:1
	dev-ruby/instance_storage:0
"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/*_test.rb || die
}
