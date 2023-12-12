# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=true test"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md Performance.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A high performance pure Ruby client for accessing memcached servers"
HOMEPAGE="https://github.com/petergoldstein/dalli"
SRC_URI="https://github.com/petergoldstein/dalli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE=""

DEPEND+="${DEPEND} test? ( >=net-misc/memcached-1.5.4[ssl(-)] )"

ruby_add_bdepend "test? (
		dev-ruby/connection_pool
		dev-ruby/minitest:5
		dev-ruby/rack
		dev-ruby/rack-session
)"

all_ruby_prepare() {
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	sed -i -e '/\(appraisal\|bundler\)/ s:^:#:' Rakefile || die

	sed -i -e '3igem "minitest", "~> 5.0"; require "dalli"' \
		-e '/bundler/ s:^:#:' test/helper.rb || die

	sed -i -e "s:/tmp:${T}:" test/utils/certificate_generator.rb || die
}
