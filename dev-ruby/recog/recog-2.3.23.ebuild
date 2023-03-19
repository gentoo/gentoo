# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="xml"

inherit ruby-fakegem

DESCRIPTION="Pattern recognition for hosts, services, and content"
HOMEPAGE="https://github.com/rapid7/recog"

LICENSE="BSD-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/nokogiri"

ruby_add_bdepend "test? (
	dev-ruby/regexp_parser
	dev-ruby/rspec:3
	dev-util/aruba:2
	dev-util/cucumber
)"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	ruby-ng_cucumber
}
