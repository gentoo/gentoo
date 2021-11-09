# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTORS README.md"

RUBY_FAKEGEM_GEMSPEC="fakefs.gemspec"

inherit ruby-fakegem

DESCRIPTION="A fake filesystem. Use it in your tests"
HOMEPAGE="https://github.com/defunkt/fakefs"
SRC_URI="https://github.com/defunkt/fakefs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	test? (
		>=dev-ruby/rspec-3.1:3
		>=dev-ruby/maxitest-3.6:1
	)"

all_ruby_prepare() {
	# Remove bundler
	rm Gemfile || die

	# Avoid unneeded minitest-rg dependency.
	sed -i -e '1igem "minitest", "~>5.5"' \
		-e '/bundler/ s:^:#:' \
		-e '/minitest\/rg/ s:^:#:' test/test_helper.rb || die

	sed -i -e 's/git ls-files/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	${RUBY} -Ilib:.:test -e 'Dir["test/**/*_test.rb"].each{|f| require f}' || die
}
