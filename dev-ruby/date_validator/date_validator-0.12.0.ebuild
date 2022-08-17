# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_EXTRADOC="Readme.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

# if ever needed
#GITHUB_USER="codegram"
#GITHUB_PROJECT="${PN}"
#RUBY_S="${GITHUB_USER}-${GITHUB_PROJECT}-*"

inherit ruby-fakegem

DESCRIPTION="Simple, ORM agnostic, Ruby 1.9 compatible date validator for Rails"
HOMEPAGE="https://github.com/codegram/date_validator"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/activemodel-3.0:*
	>=dev-ruby/activesupport-3.0:*
"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest
		>=dev-ruby/tzinfo-0.3
		>=dev-ruby/activesupport-3.0
	)
	doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	sed -i \
		-e '/git ls-files/d' \
		${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i \
		-e '/[Bb]undler/s/^/#/' Rakefile || die
	# Fix tests
	sed -i -e "1irequire 'active_support'; require 'active_support/core_ext/time/zones'" test/test_helper.rb || die
}
