# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby one-shot and periodic timers"
HOMEPAGE="https://github.com/tarcieri/timers"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "dev-ruby/hitimes"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/coveralls/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/Coveralls/ s:^:#:' spec/spec_helper.rb || die
}
