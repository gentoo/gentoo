# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="An automatic logger for HTTP requests in Ruby"
HOMEPAGE="https://github.com/chrisk/samuel"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

ruby_add_bdepend "
	test? (
		>=dev-ruby/shoulda-2.11.3
		>=dev-ruby/fakeweb-1.3
		>=dev-ruby/httpclient-2.2.3
		dev-ruby/mocha:0.14
		dev-ruby/test-unit:2
	)"

all_ruby_prepare() {
	# Remove references to bundler
	sed -i -e '/[Bb]undler/d' test/test_helper.rb || die
	rm Gemfile*

	# Change the default port from 8000 to 64888 to sidestep Issue #10.
	# https://github.com/chrisk/samuel/issues/10
	sed -i -e 's:8000:64888:g' test/*.rb || die

	# Require an old enough version of mocha.
	sed -i -e '1igem "mocha", "~> 0.14.0"' test/test_helper.rb || die

	# Use the test-unit gem for consistency accross ruby versions
	sed -i -e '1igem "test-unit"; require "test/unit"' test/test_helper.rb || die
}
