# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/maruku/maruku-0.7.2.ebuild,v 1.4 2014/11/10 16:08:44 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

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
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE="highlight test"

ruby_add_bdepend "test? ( dev-ruby/nokogiri-diff )"
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
