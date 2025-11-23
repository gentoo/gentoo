# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Console coloring"
HOMEPAGE="https://github.com/kigster/colored2"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86"

each_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die

	sed -i -e 's/Fixnum/Integer/' lib/colored2/numbers.rb || die
}
