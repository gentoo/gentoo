# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/bluecloth/bluecloth-2.2.0-r2.ebuild,v 1.6 2015/04/04 10:35:52 graaff Exp $

EAPI=5

# ruby22 -> Code uses obsolete Config module.
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem eutils

DESCRIPTION="A Ruby implementation of Markdown"
HOMEPAGE="http://www.deveiate.org/projects/BlueCloth"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

DEPEND+=" doc? ( dev-lang/perl )"

ruby_add_bdepend "
	dev-ruby/rake-compiler
	dev-ruby/hoe
	test? (
		dev-ruby/diff-lcs
		dev-ruby/tidy-ext
	)"

all_ruby_prepare() {
	# for Ruby 1.9.2 compatibility
	sed -i -e '1i $: << "."' Rakefile || die
}

all_ruby_compile() {
	rake man/man1/bluecloth.1 || die

	all_fakegem_compile
}

each_ruby_compile() {
	${RUBY} -S rake compile || die "extension build failed"
}

all_ruby_install() {
	doman man/man1/bluecloth.1

	all_fakegem_install
}
