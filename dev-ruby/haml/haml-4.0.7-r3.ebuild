# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_TASK_DOC="-Ilib doc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md FAQ.md README.md REFERENCE.md"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A ruby web page templating engine"
HOMEPAGE="http://haml-lang.com/"

LICENSE="MIT"
SLOT="4"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="doc test"

ruby_add_rdepend "dev-ruby/tilt:*"

ruby_add_bdepend "
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
