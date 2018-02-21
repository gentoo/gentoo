# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
# Needed by packages writing specs for celluloid
RUBY_FAKEGEM_EXTRAINSTALL="spec"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Provides a simple and natural way to build fault-tolerant concurrent programs"
HOMEPAGE="https://github.com/celluloid/celluloid"
IUSE=""
SLOT="0"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

ruby_add_rdepend "
	dev-ruby/celluloid-essentials
	dev-ruby/celluloid-extras
	dev-ruby/celluloid-fsm
	dev-ruby/celluloid-pool
	dev-ruby/celluloid-supervision
	>=dev-ruby/timers-4.1.1"

ruby_add_bdepend "test? (
	dev-ruby/dotenv
	dev-ruby/nenv
	dev-ruby/rspec-retry
)"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' -e '/coveralls/I s:^:#:' spec/spec_helper.rb || die

	sed -i -e '1irequire "spec_helper"' spec/celluloid/actor/system_spec.rb || die

	sed -i -e '1irequire "pathname"' spec/spec_helper.rb || die
	mkdir log || die
}
