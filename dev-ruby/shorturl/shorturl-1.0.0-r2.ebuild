# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/shorturl/shorturl-1.0.0-r2.ebuild,v 1.1 2015/04/28 18:34:11 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog.txt README.rdoc TODO.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="A very simple library to use URL shortening services such as TinyURL or RubyURL"
HOMEPAGE="http://shorturl.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~x86-macos"
IUSE=""

# All tests require network connectivity.
RESTRICT="test"

each_ruby_test() {
	${RUBY} -Ilib:test test/ts_all.rb || die "tests failed"
}

all_ruby_install() {
	all_fakegem_install

	pushd doc &>/dev/null
	dohtml -r .
	popd &>/dev/null
}
