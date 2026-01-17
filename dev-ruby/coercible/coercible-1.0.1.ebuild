# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md Changelog.md"
RUBY_FAKEGEM_GEMSPEC="coercible.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

COMMIT=c076869838531abb5783280da108aa3cbddbd61a

inherit ruby-fakegem

DESCRIPTION="Powerful, flexible and configurable coercion library"
HOMEPAGE="https://github.com/solnic/coercible https://rubygems.org/gems/coercible"
SRC_URI="https://github.com/solnic/coercible/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/descendants_tracker-0.0.1
	<dev-ruby/descendants_tracker-0.1"

ruby_add_bdepend "test? ( dev-ruby/rspec-its )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files/find * -print/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
