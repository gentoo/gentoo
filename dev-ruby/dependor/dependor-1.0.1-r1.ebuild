# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Reduces duplication when doing manual dependency injection"
HOMEPAGE="https://github.com/psyho/dependor"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -e '/simplecov/,/^end/ s:^:#:' \
		-e '/color_enabled/ s:^:#:' \
		-i spec/spec_helper.rb || die
}
