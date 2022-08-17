# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem

DESCRIPTION="Hyphenates words according to the rules of the language the word is written in"
HOMEPAGE="http://rubyforge.org/projects/text-format"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	test? (
		>=dev-ruby/hoe-2.8.0
		dev-ruby/test-unit:2
	)"

all_ruby_prepare() {
	sed -i -e '2igem "test-unit", ">= 2.0"' test/test_*.rb || die
}
