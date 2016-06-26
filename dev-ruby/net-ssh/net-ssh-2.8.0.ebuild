# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# no longer compatible with ruby 1.8.
USE_RUBY="ruby20"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc THANKS.txt"
RUBY_FAKEGEM_EXTRAINSTALL="support"

inherit ruby-fakegem

DESCRIPTION="Non-interactive SSH processing in pure Ruby"
HOMEPAGE="http://net-ssh.rubyforge.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> net-ssh-git-${PV}.tgz"

LICENSE="GPL-2"
SLOT="2.6"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="test"

ruby_add_rdepend "virtual/ruby-ssl"
ruby_add_bdepend "test? ( dev-ruby/test-unit:2 >=dev-ruby/mocha-0.13 )"

each_ruby_test() {
	${RUBY} -Ilib:test test/test_all.rb || die "Tests failed."
}
