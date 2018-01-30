# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_TASK_DOC="-Ilib doc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md FAQ.md README.md REFERENCE.md"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="A ruby web page templating engine"
HOMEPAGE="http://haml-lang.com/"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 arm ~arm64 ppc ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="doc test"

RDEPEND="${RDEPEND} !!<dev-ruby/haml-3.1.8-r2"

ruby_add_rdepend "dev-ruby/tilt:*"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
		dev-ruby/nokogiri
		dev-ruby/rails:4.2
		dev-ruby/bundler
	)
	doc? (
		dev-ruby/yard
		>=dev-ruby/maruku-0.7.2-r1
	)"

all_ruby_prepare() {
	# Remove test that fails when RedCloth is available
	sed -i -e "/should raise error when a Tilt filters dependencies are unavailable for extension/,+9 s/^/#/"\
		test/filters_test.rb || die
	# Avoid tests that are fragile for whitespace
	sed -i -e '/test_\(text_area\|partials_should_not_cause_textareas\)/,/^  end/ s:^:#:' test/helper_test.rb || die
}
