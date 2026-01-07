# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_EXTRADOC="History.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="minitar.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provides POSIX tarchive management from Ruby programs"
HOMEPAGE="https://github.com/halostatue/minitar"
SRC_URI="https://github.com/halostatue/minitar/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="minitar-${PV}"

LICENSE="|| ( BSD-2 Ruby-BSD )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.3:5 )"

all_ruby_prepare() {
	sed -e '/focus/ s:^:#:' \
		-i test/minitest_helper.rb || die

	# Fix spec broken not casting write input to strings
	sed -e '/def write/adat = dat.to_s' \
		-i test/test_tar_writer.rb || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
