# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Retry intermittently failing rspec examples"
HOMEPAGE="https://github.com/NoRedInk/rspec-retry"
IUSE=""
SLOT="0"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

ruby_add_rdepend ">=dev-ruby/rspec-core-3.3:3"

all_ruby_prepare() {
	sed -i -e '/pry/ s:^:#:' spec/spec_helper.rb || die
}
