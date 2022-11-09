# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="The complete solution for Ruby command-line executables"
HOMEPAGE="https://visionmedia.github.com/commander/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/highline:2"

all_ruby_prepare() {
	sed -i -e "/simplecov/,/end/ s:^:#:" spec/spec_helper.rb || die
}
