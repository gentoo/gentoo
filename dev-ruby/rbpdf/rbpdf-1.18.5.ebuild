# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rbpdf/rbpdf-1.18.5.ebuild,v 1.1 2015/04/11 02:59:00 mjo Exp $

EAPI=5

# As long as we conditionally depend on dev-ruby/rails:3.2, we're
# helpless to add ruby21 or ruby22 support. It should be possible, it
# just hasn't happened yet. See https://github.com/naitoh/rbpdf/issues/9
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby on Rails TCPDF plugin"
HOMEPAGE="https://github.com/naitoh/rbpdf"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# We need to set up a fake Rails environment to run the tests.
ruby_add_bdepend "test? ( dev-ruby/rails:3.2 )"

src_test() {
	# Create a fake Rails environment once, then do the default ruby-ng
	# thing. Make sure we use the rails-3.x.y executable.
	local rails="${ROOT}usr/bin/rails-3.2*"

	$rails new "${T}/dummy" \
		  --skip-javascript \
		  --skip-git \
		  --skip-bundle \
		  --skip-sprockets \
		  --skip-active-record \
		|| die "failed to create rails environment"

	ruby-ng_src_test
}

each_ruby_test() {
	# The test suite needs to run within a Rails environment, so in
	# src_test(), we created an empty Rails instance in ${T}/dummy. Now
	# we copy ourselves into the vendor/plugins directory of that Rails
	# instance, and run the tests using Rails's Rakefile. Assuming the
	# tests pass, we remove the plugin again so everything is nice and
	# tidy for the next ruby implementation.
	cp -r . "${T}/dummy/vendor/plugins/${PN}" || \
		die "failed to install plugin"
	cd "${T}/dummy" || die
	rake test TEST="vendor/plugins/${PN}/test/*_test.rb" || \
		die "test suite failed"
	rm -r "vendor/plugins/${PN}" || die "failed to uninstall plugin"
}
