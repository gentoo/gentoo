# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Set of matchers and helpers to allow you test your APIs responses."
HOMEPAGE="https://github.com/waterlink/rspec-json_expectations"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-util/cucumber )"

all_ruby_prepare() {
	sed -i -e '1irequire "forwardable"' lib/rspec/json_expectations/matchers.rb || die
}

each_ruby_test() {
	${RUBY} -S cucumber --format progress features || die
}
