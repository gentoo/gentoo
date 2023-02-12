# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_GEMSPEC="puma.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/puma_http11/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/puma

inherit ruby-fakegem

DESCRIPTION="a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack"
HOMEPAGE="https://puma.io/"
SRC_URI="https://github.com/puma/puma/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

DEPEND+=" dev-libs/openssl:0 test? ( net-misc/curl )"
RDEPEND+=" dev-libs/openssl:0="

ruby_add_bdepend "virtual/ruby-ssl
	test? ( dev-ruby/localhost dev-ruby/rack:2.2 >=dev-ruby/minitest-5.9:5 >=dev-ruby/test-unit-3.0:2 )"

ruby_add_rdepend "dev-ruby/nio4r:2"

all_ruby_prepare() {
	sed -e '/bundler/ s:^:#:' \
		-e '/prove/ s:^:#:' \
		-e '/stub_const/ s:^:#:' \
		-i test/helper.rb || die

	# Avoid tests failing inconsistently
	sed -i -e '/test_bad_client/askip "inconsistent results"' test/test_web_server.rb || die

	# Avoid launcher tests since they make assumptions about bundler use
	rm -f test/test_launcher.rb test/test_worker_gem_independence.rb test/test_bundle_pruner.rb || die

	# Skip integration tests since they make a lot of assumptions about
	# the environment
	rm -f test/test_integration_* test/test_preserve_bundler_env.rb|| die

	# Avoid test that uses unpackaged stub_const
	sed -i -e '/test_shutdown_with_grace/,/^  end/ s:^:#:' test/test_thread_pool.rb || die

	sed -e 's/git ls-files --/find/' \
		-e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	einfo "Running test suite"
	PUMA_CI_RACK_2=true ${RUBY} -Ilib:.:test -e "gem 'minitest', '~>5.9'; gem 'test-unit', '~>3.0'; gem 'rack', '<3'; require 'minitest/autorun'; Dir['test/**/*test_*.rb'].each{|f| require f}" || die
}
