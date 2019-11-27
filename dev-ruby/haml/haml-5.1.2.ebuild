# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=true test"
RUBY_FAKEGEM_TASK_DOC="-Ilib doc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md FAQ.md README.md REFERENCE.md"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A ruby web page templating engine"
HOMEPAGE="http://haml.info/"
SRC_URI="https://github.com/haml/haml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="5"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="doc test"

RDEPEND="${RDEPEND} !!<dev-ruby/haml-4.0.7-r2"

ruby_add_rdepend ">=dev-ruby/temple-0.8.0 dev-ruby/tilt:*"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
		dev-ruby/nokogiri
		dev-ruby/railties:5.2
		dev-ruby/activemodel:5.2
		dev-ruby/actionpack:5.2
	)
	doc? (
		dev-ruby/yard
		>=dev-ruby/maruku-0.7.2-r1
	)"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/bundler/I s:^:#:' \
		-e 's/gem "minitest"/gem "minitest", "~>5.0"/'\
		-e '1igem "actionpack", "~>5.2"'\
		-e '1igem "activesupport", "~>5.2"; gem "activemodel", "~>5.2"'\
		-e '1igem "railties", "~>5.2"'\
		test/test_helper.rb || die
	# Remove test that fails when RedCloth is available
	sed -i -e "/should raise error when a Tilt filters dependencies are unavailable for extension/,/^  end/ s/^/#/"\
		test/filters_test.rb || die
}
