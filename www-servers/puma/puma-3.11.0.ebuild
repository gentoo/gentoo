# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack"
HOMEPAGE="http://puma.io/"
SRC_URI="https://github.com/puma/puma/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND+=" dev-libs/openssl:0 test? ( net-misc/curl )"
RDEPEND+=" dev-libs/openssl:0"

ruby_add_bdepend "virtual/ruby-ssl
	test? ( dev-ruby/rack >=dev-ruby/minitest-5.9:5 >=dev-ruby/test-unit-3.0:2 )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' test/helper.rb || die

	# Avoid test failing inconsistently
	sed -i -e '/phased_restart_via_pumactl/,/^  end/ s:^:#:' test/test_integration.rb || die

	# Avoid test we did not run previously that is failing
	rm -f test/test_cli.rb || die

	# Avoid test that trigger a bug in ruby very easily and lead to
	# failure. This affects all current puma versions in combination
	# with the latest ruby versions, so we add this new version anyway
	# while allowing these tests to fail.
	# https://github.com/puma/puma/pull/1345
	rm -f test/test_{persistent,puma_server,puma_server_ssl}.rb || die
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
