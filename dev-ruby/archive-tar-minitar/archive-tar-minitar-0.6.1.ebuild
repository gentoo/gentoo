# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.md README.rdoc"

# We don't use RUBY_FAKEGEM_NAME here since for now we want to keep the
# same gem name.

inherit ruby-fakegem

DESCRIPTION="Provides POSIX tarchive management from Ruby programs"
HOMEPAGE="https://github.com/halostatue/minitar"
SRC_URI="mirror://rubygems/minitar-${PV}.gem"

LICENSE="|| ( BSD-2 Ruby )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.3:5 )"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
