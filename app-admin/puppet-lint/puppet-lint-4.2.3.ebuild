# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP="puppet-lint"

inherit ruby-fakegem

DESCRIPTION="A linter for puppet DSL"
HOMEPAGE="https://github.com/puppetlabs/puppet-lint"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCH_NAME="${PN}-4.2.3-pr181-fix-warnings.patch"
SRC_URI+=" https://github.com/puppetlabs/puppet-lint/pull/181.patch -> ${PATCH_NAME} "

PATCHES=(
	"${DISTDIR}/${PATCH_NAME}"
)

ruby_add_bdepend "test? (
	dev-ruby/rspec-its:1
	dev-ruby/rspec-collection_matchers:1
	dev-ruby/rspec-json_expectations )"

all_ruby_prepare() {
	# Skip acceptance tests due to unpackages puppet_litmus which in turn
	# has a number of unpackaged dependencies.
	rm -rf spec/acceptance || die
	rm -f spec/spec_helper_acceptance.rb || die
}
