# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Transform Ruby enumerators that produce data slowly and unpredictably"
HOMEPAGE="https://github.com/ddfreyne/slow_enumerator_tools/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/simplecov/,/SimpleCov.formatter/ s:^:#:' \
		-e '/fuubar/,/^end/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/Fuubar/d' .rspec || die
}
