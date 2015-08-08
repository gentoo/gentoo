# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby22 support waiting on dev-ruby/action{pack,view}.
USE_RUBY="ruby19 ruby20 ruby21"

# Avoid the complexity of the "rake" recipe and run the tests manually.
RUBY_FAKEGEM_RECIPE_TEST=none

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby on Rails TCPDF plugin"
HOMEPAGE="https://github.com/naitoh/rbpdf"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Try to pick the right version of minitest. In order to run, the test
# suite needs matching versions of actionview and activesupport. The
# easiest way to do this is to pull them in simultaneously with
# actionpack.
ruby_add_bdepend "test? ( || (
	( dev-ruby/actionpack:3.2 dev-ruby/minitest:0 )
	( dev-ruby/actionpack:4.0 dev-ruby/minitest:0 )
	( dev-ruby/actionpack:4.1 dev-ruby/minitest:5 )
	( dev-ruby/actionpack:4.2 dev-ruby/minitest:5 )
) )"

# We need the action_view gem; it was split out of actionpack in 4.1.
ruby_add_rdepend "|| (
	dev-ruby/actionpack:3.2
	dev-ruby/actionpack:4.0
	dev-ruby/actionview:*
)"

all_ruby_prepare(){
	default

	# This test is enabled automagically in the presence of rmagick, and
	# then fails.
	rm -f test/rbpdf_image_rmagick_test.rb \
		|| die "failed to remove rmagick tests"
}

each_ruby_test() {
	local cmd='gem "minitest"'
	cmd+=' and '
	cmd+='require "minitest/autorun"'
	cmd+=' and '
	cmd+='Dir["test/**/*_test.rb"].each{|f| require f}'
	${RUBY} -Ilib:.:test -e "${cmd}" || die "test suite failed"
}
