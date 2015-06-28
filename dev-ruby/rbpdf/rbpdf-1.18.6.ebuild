# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rbpdf/rbpdf-1.18.6.ebuild,v 1.1 2015/06/27 23:54:14 mjo Exp $

EAPI=5

# ruby22 support waiting on dev-ruby/action{pack,view}.
# ruby21 works, but not while we support rails-3.2.
USE_RUBY="ruby19 ruby20"

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

# Try to pick the right version of minitest. Conflicts are still
# possible, but this is probably the best we can do...
ruby_add_bdepend "test? ( || (
	( dev-ruby/actionpack:3.2 dev-ruby/minitest:0 )
	( dev-ruby/actionpack:4.0 dev-ruby/minitest:0 )
	( dev-ruby/actionview:*   dev-ruby/minitest:5 )
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
