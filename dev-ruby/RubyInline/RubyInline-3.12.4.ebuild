# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby22 -> Code uses obsolete Config module.
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem

DESCRIPTION="Allows to embed C/C++ in Ruby code"
HOMEPAGE="http://www.zenspider.com/ZSS/Products/RubyInline/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc test"

ruby_add_rdepend "dev-ruby/zentest"

ruby_add_bdepend "
	test? (
		>=dev-ruby/hoe-3
		dev-ruby/hoe-seattlerb
		dev-ruby/minitest:5
	)"

RUBY_PATCHES=(
	ruby-inline-3.12.2-gentoo.patch
	ruby-inline-3.11.1-ldflags.patch
)

all_ruby_prepare() {
	sed -i -e '/isolate/ s:^:#:' Rakefile || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc example.rb example2.rb demo/*.rb
}
