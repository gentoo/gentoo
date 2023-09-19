# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.md doc/*.rdoc doc/releases/*"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="flexmock.gemspec"

inherit ruby-fakegem

DESCRIPTION="Simple mock object library for Ruby unit testing"
HOMEPAGE="https://github.com/doudou/flexmock"
SRC_URI="https://github.com/doudou/flexmock/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="flexmock"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

PATCHES=( "${FILESDIR}"/flexmock-2.3.6-ruby30-{1,2,3}.patch )

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
		dev-ruby/rspec:3
	)"

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec test/rspec_integration
	MT_NO_PLUGINS=1 ${RUBY} -Ilib:.:test -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}

all_ruby_prepare() {
	sed -i -e '1igem "minitest", "~>5.0"' test/test_helper.rb || die

	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
