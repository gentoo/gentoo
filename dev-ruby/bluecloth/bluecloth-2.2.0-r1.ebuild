# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem eutils

DESCRIPTION="A Ruby implementation of Markdown"
HOMEPAGE="http://www.deveiate.org/projects/BlueCloth"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

DEPEND+=" doc? ( dev-lang/perl )"

ruby_add_bdepend "
	dev-ruby/hoe
	dev-ruby/rake-compiler
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
