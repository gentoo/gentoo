# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack"
HOMEPAGE="http://puma.io/"
SRC_URI="https://github.com/puma/puma/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

DEPEND+=" dev-libs/openssl:0"
RDEPEND+=" dev-libs/openssl:0"

ruby_add_bdepend "virtual/ruby-ssl
	test? ( dev-ruby/rack )"

all_ruby_prepare() {
	# Avoid test failing inconsistently
	sed -i -e '/phased_restart_via_pumactl/,/^  end/ s:^:#:' test/test_integration.rb || die
}

each_ruby_prepare() {
	sed -i -e 's:ruby:'${RUBY}':' test/shell/run.sh || die
}

each_ruby_configure() {
	${RUBY} -Cext/puma_http11 extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/puma_http11
	cp ext/puma_http11/puma_http11$(get_modname) lib/puma/ || die
}

each_ruby_test() {
	einfo "Running test suite"
	${RUBY} -Ilib:.:test -e "Dir['test/**/*test_*.rb'].each{|f| require f}" || die

	einfo "Running integration tests"
	pushd test/shell
	sh run.sh
	popd
}
