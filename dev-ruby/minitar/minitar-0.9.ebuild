# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_EXTRADOC="History.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="minitar.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provides POSIX tarchive management from Ruby programs"
HOMEPAGE="https://github.com/halostatue/minitar"
SRC_URI="https://github.com/halostatue/minitar/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="minitar-${PV}"

LICENSE="|| ( BSD-2 Ruby )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.3:5 )"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
