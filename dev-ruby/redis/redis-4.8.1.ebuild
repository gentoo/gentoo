# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

MY_P="redis-rb-${PV}"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="redis.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Ruby client library for Redis"
HOMEPAGE="https://github.com/redis/redis-rb"
SRC_URI="https://github.com/redis/redis-rb/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm64"
IUSE="doc test"

DEPEND="test? ( >=dev-db/redis-7 )"

RUBY_S="${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-4.8.0-local-redis-server.patch" )

ruby_add_bdepend "test? (
	dev-ruby/minitest
	dev-ruby/mocha
)"

all_ruby_prepare() {
	sed -i -e 's/git ls-files --/echo/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/test_connection_timeout/askip "requires network"' test/redis/internals_test.rb || die
	sed -e '/test_defaults_to_localhost/askip "assumes localhost == 127.0.0.1"' \
		-i test/redis/url_param_test.rb || die

	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}

each_ruby_test() {
	RUBY=${RUBY} TMP=${T} MT_NO_PLUGINS=true VERBOSE=true emake -j1 all
	einfo "Wait 5 seconds for servers to stop"
	sleep 5
}
