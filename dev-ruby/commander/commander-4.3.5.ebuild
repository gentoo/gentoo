# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="The complete solution for Ruby command-line executables"
HOMEPAGE="https://visionmedia.github.com/commander/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/highline-1.7.2"

all_ruby_prepare() {
	sed -i -e "/simplecov/,/end/ s:^:#:" spec/spec_helper.rb || die
}
