# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem
DESCRIPTION="Pluggaloid is extensible plugin system for mikutter"
HOMEPAGE="https://rubygems.org/gems/pluggaloid/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/delayer
	dev-ruby/instance_storage:0
"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/*_test.rb || die
}
