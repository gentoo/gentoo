# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=true test"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.md Performance.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A high performance pure Ruby client for accessing memcached servers"
HOMEPAGE="https://github.com/petergoldstein/dalli"
SRC_URI="https://github.com/petergoldstein/dalli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 x86"
IUSE=""

DEPEND+="${DEPEND} test? ( >=net-misc/memcached-1.5.4[ssl(-)] )"

ruby_add_bdepend "test? (
		dev-ruby/minitest:5
		dev-ruby/rack
)"

all_ruby_prepare() {
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	sed -i -e '/\(appraisal\|bundler\)/ s:^:#:' Rakefile || die

	sed -i -e '3igem "minitest", "~> 5.0"; require "dalli"' \
		-e '/bundler/ s:^:#:' test/helper.rb || die

	sed -i -e "s:/tmp:${T}:" test/utils/certificate_generator.rb || die
}
