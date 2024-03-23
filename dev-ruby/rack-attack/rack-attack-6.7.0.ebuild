# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

# Skip integration tests since they require additional unpackaged
# dependencies and running daemons.
RUBY_FAKEGEM_TASK_TEST="test:units"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A DSL for blocking & throttling abusive clients"
HOMEPAGE="https://github.com/rack/rack-attack"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "dev-ruby/rack:*"
ruby_add_bdepend "test? (
	dev-ruby/actionpack
	dev-ruby/activesupport
	dev-ruby/railties
	dev-ruby/rack-test
	dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|byebug\)/ s:^:#:' Rakefile spec/spec_helper.rb || die
	sed -i -e '3igem "actionpack"' spec/spec_helper.rb || die
	sed -i -e '/rubocop/I s:^:#:' Rakefile || die

	# Fix minitest deprecation
	sed -i -e 's/MiniTest/Minitest/' spec/spec_helper.rb || die

	# Avoid specs requiring a live redis service
	sed -i -e '/should delete rack attack key/askip "requires redis service"' spec/rack_attack_spec.rb || die
}
