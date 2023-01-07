# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="Readme.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Minitest + all the features you always wanted"
HOMEPAGE="https://github.com/grosser/maxitest"
SRC_URI="https://github.com/grosser/maxitest/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "<dev-ruby/minitest-5.18:5"

ruby_add_bdepend "test? ( dev-ruby/bundler )"

all_ruby_prepare() {
	rm -f Gemfile.lock || die
	# Remove developer-only gems from the gemspec and avoid git issues
	sed -i -e '/wwtd/ s:^:#:' \
		-e 's/git ls-files/find */' \
		${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/\(byebug\|bump\)/ s:^:#:' Gemfile || die

	sed -e '/shows short backtraces/askip "fails on ruby27"' \
		-e '/fails when not used/askip "fails with newer maxitest by design"' \
		-e '/shows version/askip "fails due to missing require for version"' \
		-i spec/maxitest_spec.rb || die
}

each_ruby_prepare() {
	# Use the correct target
	sed -i -e '/sh/ s:ruby:'${RUBY}':' \
		-e '/sh/ s:mtest:'${RUBY}' -S mtest:' \
		spec/maxitest_spec.rb || die
}

each_ruby_test() {
	PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" RSPEC_VERSION=3 ruby-ng_rspec spec
}
