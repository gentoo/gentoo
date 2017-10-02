# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="https://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~amd64"
SLOT="3.0"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/unindent-1.0
	)"

ruby_add_rdepend "
	>=dev-ruby/backports-3.8.0
	>=dev-util/cucumber-tag_expressions-1.0.1
	>=dev-ruby/gherkin-4.1.3
"

all_ruby_prepare() {
	# Avoid dependency on kramdown to keep dependency list manageable for all arches.
	rm -f spec/readme_spec.rb || die
}
