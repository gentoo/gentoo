# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="docs/div_syntax.md docs/entity_test.md
	docs/markdown_syntax.md docs/maruku.md docs/math.md docs/other_stuff.md
	docs/proposal.md"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="A Markdown-superset interpreter written in Ruby"
HOMEPAGE="https://github.com/bhollis/maruku"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 x86 ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="highlight test"

ruby_add_bdepend "test? ( dev-ruby/nokogiri-diff dev-ruby/syntax )"
ruby_add_rdepend "highlight? ( dev-ruby/syntax )"

DEPEND+=" test? ( app-text/blahtexml )"

all_ruby_prepare() {
	sed -i -e '/[Ss]imple[Cc]ov/ s:^:#:' spec/spec_helper.rb || die
}

pkg_postinst() {
	elog
	elog "You need to emerge app-text/texlive and dev-texlive/texlive-latexextra if"
	elog "you want to use --pdf with Maruku. You may also want to emerge"
	elog "dev-texlive/texlive-latexrecommended to enable LaTeX syntax highlighting."
	elog
}
