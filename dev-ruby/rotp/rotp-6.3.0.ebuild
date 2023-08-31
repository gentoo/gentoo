# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="The Ruby One Time Password Library"
HOMEPAGE="https://github.com/mdp/rotp"
SRC_URI="https://github.com/mdp/rotp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/openssl"

ruby_add_bdepend "
	test? (	>=dev-ruby/timecop-0.8 )
"

all_ruby_prepare() {
	# Remove simplecov
	sed -i -e '/simplecov/,/^end/ s:^:#:' -e '2irequire "uri"; require "cgi"' spec/spec_helper.rb || die
	# Don't require git
	sed -i \
		-e 's/git ls-files/find/' \
		-e 's/{test,spec,features}/spec/' \
		${RUBY_FAKEGEM_GEMSPEC} || die
}
