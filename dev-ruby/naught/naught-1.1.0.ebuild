# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.markdown"

inherit ruby-fakegem

DESCRIPTION="A toolkit for building Null Objects in Ruby"
HOMEPAGE="https://github.com/avdi/naught"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^end/ s:^:#:' spec/spec_helper.rb || die
}
