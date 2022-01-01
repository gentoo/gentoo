# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md docs/TEMPLATES.md"

inherit ruby-fakegem

DESCRIPTION="Thin interface over template engines to make their usage as generic as possible"
HOMEPAGE="https://github.com/rtomayko/tilt"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Block on some of the potential test dependencies. These dependencies
# are optional for the test suite, and we don't want to depend on all of
# them to faciliate keywording and stabling.
ruby_add_bdepend "test? (
	dev-ruby/coffee-script
	dev-ruby/erubis
	dev-ruby/nokogiri
	!!<dev-ruby/maruku-0.7.2 )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -e '/bundler/I s:^:#:' -i Rakefile test/test_helper.rb || die

	# Avoid tests with minor syntax differences since this happens all
	# the time when details in the dependencies change.
	sed -e '/test_smarty_pants_true/,/^    end/ s:^:#:' \
		-e '/test_smart_quotes_true/,/^  end/ s:^:#:' -i test/tilt_markdown_test.rb || die
	sed -e '/smartypants when :smart is set/,/^    end/ s:^:#:' -i test/tilt_rdiscounttemplate_test.rb || die
}
