# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby23: fails tests
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="A pure Ruby implementation of the SCP client protocol"
HOMEPAGE="https://github.com/net-ssh/net-scp"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	doc? ( >=dev-ruby/net-ssh-2.6.5:2.6 )
	test? (
		>=dev-ruby/net-ssh-2.9.0:2.6
		dev-ruby/mocha
	)"

ruby_add_rdepend ">=dev-ruby/net-ssh-2.6.5:2.6"

all_ruby_prepare() {
	sed -i -e 's/>= 2.0.0/~> 2.0/' test/common.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/test_all.rb || die
}
