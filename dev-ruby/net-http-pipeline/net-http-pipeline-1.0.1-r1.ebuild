# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

inherit ruby-fakegem

DESCRIPTION="An HTTP/1.1 pipelining implementation atop Net::HTTP"
HOMEPAGE="https://docs.seattlerb.org/net-http-pipeline/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "
	test? ( dev-ruby/minitest )
"

all_ruby_prepare() {
	eapply -p0 "${FILESDIR}/${PN}-accept-encoding.patch"

	sed -e 's/MiniTest::Unit::TestCase/Minitest::Test/' \
		-i test/test_net_http_pipeline.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
