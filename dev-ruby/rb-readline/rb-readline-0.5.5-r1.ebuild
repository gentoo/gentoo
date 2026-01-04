# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

inherit ruby-fakegem

DESCRIPTION="Ruby implementation of the GNU readline C library"
HOMEPAGE="https://rubygems.org/gems/rb-readline"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_bdepend "dev-ruby/rake
		>=dev-ruby/minitest-5.2:5"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	# Skip a test that fails when run in the ebuild environment.
	sed -e '/test_readline_with_default_parameters_does_not_error/,/end/ s:^:#:' \
		-i test/test_readline.rb || die

	sed -e '1igem "minitest", "~> 5.0"' \
		-i test/test_*.rb
}
