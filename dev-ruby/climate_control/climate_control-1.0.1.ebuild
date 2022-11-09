# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="NEWS README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Easily manage your environment"
HOMEPAGE="https://github.com/thoughtbot/climate_control"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	# Avoid dependencies on simplecov and git.
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's/git ls-files/find * -print/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
