# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem

DESCRIPTION="Hyphenates various words according to the rules of the language the word is written in"
HOMEPAGE="http://rubyforge.org/projects/text-format"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	doc? (
		>=dev-ruby/hoe-2.8.0
	)
	test? (
		>=dev-ruby/hoe-2.8.0
		dev-ruby/test-unit:2
	)"

all_ruby_prepare() {
	sed -i -e '2igem "test-unit", ">= 2.0"' test/test_*.rb || die
}
