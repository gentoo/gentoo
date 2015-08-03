# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/net-ssh/net-ssh-2.10.0.ebuild,v 1.1 2015/08/03 05:50:39 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc THANKS.txt"
RUBY_FAKEGEM_EXTRAINSTALL="support"

inherit ruby-fakegem

DESCRIPTION="Non-interactive SSH processing in pure Ruby"
HOMEPAGE="https://github.com/net-ssh/net-ssh"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> net-ssh-git-${PV}.tgz"

LICENSE="GPL-2"
SLOT="2.6"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="test"

ruby_add_rdepend "virtual/ruby-ssl"
ruby_add_bdepend "test? ( dev-ruby/test-unit:2 >=dev-ruby/mocha-0.13 )"

each_ruby_test() {
	${RUBY} -Ilib:test test/test_all.rb || die "Tests failed."
}
