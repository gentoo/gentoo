# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

MY_P="redis-rb-${PV}"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

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

PATCHES=( "${FILESDIR}/${P}-local-redis-server.patch" )

all_ruby_prepare() {
	# call me impatient, but this way we don't need netcat
	sed -i \
		-e '/test_subscribe_past_a_timeout/,+18d' \
		test/publish_subscribe_test.rb || die "sed failed"
}

each_ruby_test() {
	RUBY=${RUBY} emake test
}
