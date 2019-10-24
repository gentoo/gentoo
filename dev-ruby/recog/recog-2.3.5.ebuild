# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"
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
	dev-ruby/regexp_parser:0
	dev-ruby/rspec:3
	dev-util/aruba
	dev-util/cucumber
)"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' -e '1igem "regexp_parser", "~>0.2"' spec/spec_helper.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	ruby-ng_cucumber
}
