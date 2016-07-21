# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_TASK_DOC="-Ilib doc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md FAQ.md README.md REFERENCE.md"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="A ruby web page templating engine"
HOMEPAGE="http://haml-lang.com/"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="doc test"

RDEPEND="${RDEPEND} !!<dev-ruby/haml-3.1.8-r2"

ruby_add_rdepend "dev-ruby/tilt:*"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
		dev-ruby/nokogiri
		dev-ruby/rails:4.2
	)
	doc? (
		dev-ruby/yard
		>=dev-ruby/maruku-0.7.2-r1
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' \
		-e 's/gem "minitest"/gem "minitest", "~>5.0"/'\
		-e '1igem "actionpack", "~>4.2"'\
		-e '1igem "activesupport", "~>4.2"'\
		-e '1igem "railties", "~>4.2"'\
		test/test_helper.rb || die
	# Remove test that fails when RedCloth is available
	sed -i -e "/should raise error when a Tilt filters dependencies are unavailable for extension/,+9 s/^/#/"\
		test/filters_test.rb || die
}
