# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/cocaine/cocaine-0.5.7.ebuild,v 1.1 2015/04/22 05:27:30 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A small library for doing command lines"
HOMEPAGE="http://www.thoughtbot.com/projects/cocaine"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/climate_control:0"

ruby_add_bdepend "
	test? (
		>=dev-ruby/activesupport-3  <dev-ruby/activesupport-5
		dev-ruby/bourne
		<dev-ruby/mocha-1.0.0
		dev-ruby/posix-spawn
	)"

all_ruby_prepare() {
	sed -i \
		-e '/git ls-files/d' \
		"${RUBY_FAKEGEM_GEMSPEC}" || die

	rm Gemfile* || die

	sed -i -e '/bundler/d' Rakefile || die

	sed -i -e '/pry/ s:^:#:' spec/spec_helper.rb || die

	# BufferedLogger is deprecated in activesupport-4.0, and removed in 4.1
	# Require active_support not active_support/buffered_logger.
	sed -i -e 's/\/buffered_logger//g' spec/spec_helper.rb || die
}
