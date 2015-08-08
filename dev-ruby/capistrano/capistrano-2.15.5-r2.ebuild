# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A distributed application deployment system"
HOMEPAGE="http://capistranorb.com/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/net-ssh-2.0.14
	>=dev-ruby/net-sftp-2.0.2
	>=dev-ruby/net-scp-1.0.2
	>=dev-ruby/net-ssh-gateway-1.1.0
	>=dev-ruby/highline-1.2.7"
ruby_add_bdepend "
	test? (	dev-ruby/mocha:0.14 )"

RUBY_PATCHES=( ${P}-sudo-cleanup.patch )

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile test/utils.rb || die
	sed -i -e '/pry/ s:^:#:' -e '4igem "mocha", "~>0.14.0"' test/utils.rb || die

	# Avoid copy strategy tests since these fail in some cases due to
	# complicated (aka unknown) interactions with other parts of the
	# test suite.
	rm test/deploy/strategy/copy_test.rb || die
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper cap /usr/bin/cap-2 'gem "capistrano", "~>2.0"'
}
