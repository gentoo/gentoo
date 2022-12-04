# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md docs/TEMPLATES.md"

RUBY_FAKEGEM_GEMSPEC="tilt.gemspec"

inherit ruby-fakegem

DESCRIPTION="Thin interface over template engines to make their usage as generic as possible"
HOMEPAGE="https://github.com/rtomayko/tilt"
SRC_URI="https://github.com/rtomayko/tilt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Block on some of the potential test dependencies. These dependencies
# are optional for the test suite, and we don't want to depend on all of
# them to faciliate keywording and stabling.
ruby_add_bdepend "test? (
	dev-ruby/erubis
	dev-ruby/nokogiri
)"

all_ruby_prepare() {
	rm Gemfile || die
	sed -e '/bundler/I s:^:#:' -i Rakefile test/test_helper.rb || die

	# Avoid tests with minor syntax differences since this happens all
	# the time when details in the dependencies change.
	rm -f test/tilt_sasstemplate_test.rb || die

	# Skip tests for unpackaged asciidoctor converter
	sed -i -e '/docbook 4.5/askip' test/tilt_asciidoctor_test.rb || die
}
