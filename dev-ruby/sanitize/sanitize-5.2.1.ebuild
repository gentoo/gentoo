# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Sanitize is a whitelist-based HTML sanitizer"
HOMEPAGE="https://github.com/rgrove/sanitize"
SRC_URI="https://github.com/rgrove/sanitize/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/crass-1.0.2 =dev-ruby/crass-1.0*
	>=dev-ruby/nokogiri-1.8.0
	dev-ruby/nokogumbo:2"
ruby_add_bdepend "test? ( dev-ruby/minitest )"

each_ruby_test() {
	${RUBY} -Ilib test/test_sanitize.rb || die
}
