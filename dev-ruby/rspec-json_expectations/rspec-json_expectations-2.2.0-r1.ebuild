# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Set of matchers and helpers to allow you test your APIs responses"
HOMEPAGE="https://github.com/waterlink/rspec-json_expectations"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rspec dev-util/cucumber )"

each_ruby_test() {
	${RUBY} -S cucumber --format progress features || die
}
