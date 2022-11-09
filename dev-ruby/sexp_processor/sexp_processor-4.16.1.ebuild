# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem

DESCRIPTION="Processor for s-expressions created as part of the ParseTree project"
HOMEPAGE="https://www.zenspider.com/projects/sexp_processor.html"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~alpha amd64 arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	test? (
		>=dev-ruby/minitest-5.5
	)"

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
