# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/webmock/webmock-1.19.0.ebuild,v 1.6 2015/02/20 11:23:20 ago Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST="test spec NO_CONNECTION=true"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Allows stubbing HTTP requests and setting expectations on HTTP requests"
HOMEPAGE="http://github.com/bblimke/webmock"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/addressable-2.3.6 >=dev-ruby/crack-0.3.2"

ruby_add_bdepend "test? (
	dev-ruby/rspec:2
	>=dev-ruby/httpclient-2.2.4
	)"

ruby_add_bdepend "test? ( >=dev-ruby/patron-0.4.18 >=dev-ruby/http-0.5.0 )"

all_ruby_prepare() {
	# Remove bundler support
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# There is now optional support for curb and typhoeus which we don't
	# have in Gentoo yet. em_http_request is available in Gentoo but its
	# version is too old.
	sed -i -e '/\(curb\|typhoeus\|em-http\)/d' spec/spec_helper.rb || die
	rm spec/acceptance/{typhoeus,curb,excon,em_http_request}/* || die
}

each_ruby_test() {
	each_fakegem_test

	einfo "Delay to allow the test server to stop"
	sleep 10
}
