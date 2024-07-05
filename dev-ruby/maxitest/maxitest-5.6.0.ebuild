# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Minitest + all the features you always wanted"
HOMEPAGE="https://github.com/grosser/maxitest"
SRC_URI="https://github.com/grosser/maxitest/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/minitest-5.14.0:* <dev-ruby/minitest-5.25.0:*"

ruby_add_bdepend "test? ( dev-ruby/bundler >=dev-ruby/minitest-5.21.0 )"

all_ruby_prepare() {
	rm -f Gemfile.lock || die
	# Remove developer-only gems from the gemspec and avoid git issues
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -e '/\(debug\|bump\)/ s:^:#:' \
		-i Gemfile || die

	sed -e '/shows backtrace for/askip' \
		-e '/describe.*line/ s/describe/xdescribe/' \
		-e '/describe.*color/ s/describe/xdescribe/' \
		-i spec/maxitest_spec.rb || die
}

each_ruby_prepare() {
	# Use the correct target
	sed -e '/\(run_cmd\|sh\)/ s:ruby:'${RUBY}':' \
		-e '/\(run_cmd\|sh\)/ s:mtest:'${RUBY}' -S bin/mtest:' \
		-i spec/maxitest_spec.rb || die
}

each_ruby_test() {
	PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" RSPEC_VERSION=3 ruby-ng_rspec spec
}
