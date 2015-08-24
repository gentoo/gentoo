# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

RUBY_FAKEGEM_TASK_TEST="none"

inherit ruby-fakegem

DESCRIPTION="A library for controlling multiple Net::SSH connections via a single interface"
HOMEPAGE="https://net-ssh.github.com/net-ssh-multi"
SRC_URI="https://github.com/net-ssh/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/net-ssh-2.6.5
	>=dev-ruby/net-ssh-gateway-1.2.0"

ruby_add_bdepend "test? ( dev-ruby/mocha )"

each_ruby_test() {
	${RUBY} -Ilib:test test/test_all.rb || die
}
