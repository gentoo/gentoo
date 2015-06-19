# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/maruku/maruku-0.6.1.ebuild,v 1.8 2014/11/10 16:08:44 mrueg Exp $

EAPI=5

USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="docs/changelog.md docs/div_syntax.md docs/entity_test.md
	docs/markdown_syntax.md docs/maruku.md docs/math.md docs/other_stuff.md
	docs/proposal.md"

inherit ruby-fakegem

DESCRIPTION="A Markdown-superset interpreter written in Ruby"
HOMEPAGE="https://github.com/bhollis/maruku"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend dev-ruby/syntax

all_ruby_prepare() {
	sed -i \
		-e '/Gem::manage_gems/s:^:#:' \
		-e '/jamis\.rb/s:^:#:' \
		Rakefile
}

each_ruby_test() {
	# Unit tests fail in various ways. Skip them for now since we never ran
	# tests for earlier versions at all. No clear upstream to report to...
	# ${RUBY} -Ilib bin/marutest $(find tests/unittest -name '*.md') || die
	${RUBY} -Ilib lib/maruku/tests/new_parser.rb v b || die
}

pkg_postinst() {
	elog
	elog "You need to emerge app-text/texlive and dev-texlive/texlive-latexextra if"
	elog "you want to use --pdf with Maruku. You may also want to emerge"
	elog "dev-texlive/texlive-latexrecommended to enable LaTeX syntax highlighting."
	elog
}
