# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

# There are functional tests that require vagrant boxes to be set up.
RUBY_FAKEGEM_TASK_TEST="test:units"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md FAQ.md README.md"

inherit ruby-fakegem

DESCRIPTION="SSHKit makes it easy to write structured, testable SSH commands in Ruby"
HOMEPAGE="https://github.com/capistrano/sshkit"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/net-ssh-2.8.0:*
	>=dev-ruby/net-scp-1.1.2
"

ruby_add_bdepend "test? ( dev-ruby/minitest dev-ruby/mocha )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile test/helper.rb || die
	sed -i -e '/\(turn\|unindent\)/I s:^:#:' test/helper.rb || die

	# Fix assumption about parent directory name
	sed -i -e '/assert_match/ s/sshkit/sshkit.*/' test/unit/test_deprecation_logger.rb || die
}
