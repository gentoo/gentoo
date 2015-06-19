# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mocha/mocha-0.12.10-r1.ebuild,v 1.4 2015/04/06 15:55:24 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="test:units"

RUBY_FAKEGEM_TASK_DOC="yardoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc RELEASE.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

inherit ruby-fakegem

DESCRIPTION="A Ruby library for mocking and stubbing using a syntax like that of JMock, and SchMock"
HOMEPAGE="http://gofreerange.com/mocha/docs/"

LICENSE="MIT"
SLOT="0.12"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? ( >=dev-ruby/test-unit-2.5.1-r1 )"

ruby_add_rdepend "dev-ruby/metaclass" #metaclass ~> 0.0.1

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' -e '1iload "lib/mocha/version.rb"' Rakefile || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc; then
		rake examples || die
	fi
}

each_ruby_test() {
	ruby-ng_testrb-2 test/unit/*
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*.rb || die
}
