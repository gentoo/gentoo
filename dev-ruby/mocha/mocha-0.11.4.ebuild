# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mocha/mocha-0.11.4.ebuild,v 1.18 2014/10/30 15:53:52 mrueg Exp $

EAPI=4
USE_RUBY="ruby19 "

RUBY_FAKEGEM_TASK_TEST="test:units"

RUBY_FAKEGEM_TASK_DOC="yardoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc RELEASE.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

inherit ruby-fakegem

DESCRIPTION="A Ruby library for mocking and stubbing using a syntax like that of JMock, and SchMock"
HOMEPAGE="http://gofreerange.com/mocha/docs/"

LICENSE="MIT"
SLOT="0.11"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	doc? ( dev-ruby/yard )"

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
	${RUBY} -Ilib -S testrb test/unit/* || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*.rb || die
}
