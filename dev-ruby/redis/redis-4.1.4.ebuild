# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

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
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="test? ( >=dev-db/redis-3.2.0 )"

RUBY_S="${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-4.1.4-local-redis-server.patch" )

all_ruby_prepare() {
	# call me impatient, but this way we don't need netcat
	sed -i \
		-e '/test_subscribe_past_a_timeout/,+18d' \
		test/publish_subscribe_test.rb || die "sed failed"

	sed -i -e 's/git ls-files --/echo/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/test_connection_timeout/askip "requires network"' test/internals_test.rb || die
}

each_ruby_test() {
	RUBY=${RUBY} TMP=${T} MT_NO_PLUGINS=true emake -j1 all
	einfo "Wait 5 seconds for servers to stop"
	sleep 5
}
