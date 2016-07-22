# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A simple library to assist in enabling tunneled Net::SSH connections"
HOMEPAGE="https://github.com/net-ssh/net-scp"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "dev-ruby/test-unit:2
	<dev-ruby/mocha-1"

ruby_add_rdepend ">=dev-ruby/net-ssh-2.6.5"

all_ruby_prepare() {
	sed -i -e "1igem 'mocha', '~>0.10'" test/gateway_test.rb || die
}

each_ruby_test() {
	RUBYLIB=lib ruby-ng_testrb-2 test/*
}
