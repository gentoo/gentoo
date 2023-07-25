# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTORS README.md"

RUBY_FAKEGEM_GEMSPEC="fakefs.gemspec"

inherit ruby-fakegem

DESCRIPTION="A fake filesystem. Use it in your tests"
HOMEPAGE="https://github.com/fakefs/fakefs"
SRC_URI="https://github.com/fakefs/fakefs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~hppa ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
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
	sed -i -e '1igem "maxitest"; gem "minitest", "~>5.5"' \
		-e '/bundler/ s:^:#:' \
		-e '/minitest\/rg/ s:^:#:' test/test_helper.rb || die

	sed -i -e 's/git ls-files/find */' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid test that uses the console and hangs on user input
	rm -f test/pry_test.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	${RUBY} -Ilib:.:test -e 'Dir["test/**/*_test.rb"].each{|f| require f}' || die
}
