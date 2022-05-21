# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="cucumber-core.gemspec"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="https://cucumber.io/"
SRC_URI="https://github.com/cucumber/cucumber-ruby-core/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="cucumber-ruby-core-${PV}"
LICENSE="Ruby"

KEYWORDS="~amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc ~x86"
SLOT="$(ver_cut 1)"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/unindent-1.0
	)"

ruby_add_rdepend "
	>=dev-util/cucumber-gherkin-22.0.0:22
	>=dev-util/cucumber-messages-17.1.1:17
	>=dev-util/cucumber-tag-expressions-4.0.2:4
"

all_ruby_prepare() {
	# Avoid dependency on kramdown to keep dependency list manageable for all arches.
	rm -f spec/readme_spec.rb || die
}
