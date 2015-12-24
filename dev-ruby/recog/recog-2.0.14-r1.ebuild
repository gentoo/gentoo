# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Pattern recognition for hosts, services, and content"
HOMEPAGE="https://github.com/rapid7/recog"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/nokogiri
		!<dev-ruby/recog-2.0.6-r1"

ruby_add_bdepend "test? (
	dev-ruby/regexp_parser
	dev-ruby/rspec:3
	dev-util/aruba
	dev-util/cucumber
)"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	ruby-ng_cucumber
}
