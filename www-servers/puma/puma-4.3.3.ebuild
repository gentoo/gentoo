# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_GEMSPEC="puma.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack"
HOMEPAGE="https://puma.io/"
SRC_URI="https://github.com/puma/puma/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND+=" dev-libs/openssl:0 test? ( net-misc/curl )"
RDEPEND+=" dev-libs/openssl:0"

ruby_add_bdepend "virtual/ruby-ssl
	test? ( dev-ruby/rack >=dev-ruby/minitest-5.9:5 >=dev-ruby/test-unit-3.0:2 )"

ruby_add_rdepend "dev-ruby/nio4r:2"

all_ruby_prepare() {
	sed -e '/bundler/ s:^:#:' \
		-e '/prove/ s:^:#:' \
		-i test/helper.rb || die

	# Avoid tests failing inconsistently
	sed -i -e '/phased_restart_via_pumactl/,/^  end/ s:^:#:' test/test_integration_pumactl.rb || die
	sed -i -e '/test_bad_client/askip "inconsistent results"' test/test_web_server.rb || die

	# Loosen timing on flakey test
	#sed -i -e '390 s/sleep 2/sleep 4/' test/test_integration.rb || die

	# Use correct ruby version
	sed -i -e 's/ruby -rrubygems/#{Gem.ruby} -rrubygems/' test/shell/t{1,3}.rb || die

	# Avoid launcher tests since they make assumptions about bundler use
	rm -f test/test_launcher.rb || die

	sed -i -e 's/git ls-files --/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	sed -i -e 's:ruby -rubygems:'${RUBY}' -rubygems:' \
		-e 's/localhost/127.0.0.1/' test/shell/* || die
	sed -i -e '1ilog_requests' test/shell/t{1,2}_conf.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/puma_http11 extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/puma_http11
	cp ext/puma_http11/puma_http11$(get_modname) lib/puma/ || die
}

each_ruby_test() {
	einfo "Running test suite"
	${RUBY} -Ilib:.:test -e "gem 'minitest', '~>5.9'; gem 'test-unit', '~>3.0'; require 'minitest/autorun'; Dir['test/**/*test_*.rb'].each{|f| require f}" || die

	einfo "Running integration tests"
	pushd test/shell
	#sh run.sh || die
	popd
}
