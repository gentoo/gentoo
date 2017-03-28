# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby implementation of JSDeferred"
HOMEPAGE="https://github.com/toshia/delayer-deferred"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/delayer-0.0.2:0"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/helper.rb || die
}
