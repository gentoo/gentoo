# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby22 support waiting on dev-ruby/action{pack,view}.
USE_RUBY="ruby20 ruby21"

# Avoid the complexity of the "rake" recipe and run the tests manually.
RUBY_FAKEGEM_RECIPE_TEST=none

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby on Rails RBPDF plugin"
HOMEPAGE="https://github.com/naitoh/rbpdf"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-3 )"
ruby_add_rdepend "dev-ruby/actionview:*
	dev-ruby/htmlentities
	dev-ruby/rbpdf-font"

all_ruby_prepare() {
	default

	# This test is enabled automagically in the presence of rmagick, and
	# then fails.
	rm -f test/rbpdf_image_rmagick_test.rb \
		|| die "failed to remove rmagick tests"

	# Loosen very restrictive htmlentities dependency
	sed -i -e '/htmlentities/ s/=/>=/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	local cmd='gem "test-unit", ">= 3.0"'
	cmd+=' and '
	cmd+='require "test/unit"'
	cmd+=' and '
	cmd+='Dir["test/rbpdf_*.rb"].each{|f| require("./" +  f)}'
	${RUBY} -Ilib:.:test -e "${cmd}" || die "test suite failed"
}
