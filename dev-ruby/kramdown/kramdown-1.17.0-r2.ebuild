# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="README.md AUTHORS CONTRIBUTERS"

RUBY_FAKEGEM_EXTRAINSTALL="data"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Yet-another-markdown-parser but fast, pure Ruby, using strict syntax definition"
HOMEPAGE="https://kramdown.gettalong.org/"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
IUSE="latex"

LATEX_DEPS="latex? ( dev-texlive/texlive-latex dev-texlive/texlive-latexextra )"
RDEPEND+=" ${LATEX_DEPS}"
DEPEND+=" test? ( ${LATEX_DEPS} app-text/htmltidy )"

ruby_add_rdepend "dev-ruby/prawn:2
	>=dev-ruby/prawn-table-0.2.2 =dev-ruby/prawn-table-0.2*
	>=dev-ruby/rouge-1.8
	>=dev-ruby/itextomml-1.5
	>=dev-ruby/coderay-1.0.0
	>=dev-ruby/ritex-1.0
	>=dev-ruby/stringex-1.5.1"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )
	test? ( >=dev-ruby/minitest-5.0 )"

all_ruby_prepare() {
	if ! use latex; then
		# Remove latex tests. They will fail gracefully when latex isn't
		# present at all, but not when components are missing (most
		# notable ucs.sty).
		sed -i -e '/latex -v/,/^  end/ s:^:#:' test/test_files.rb || die
	fi

	# Avoid tests requiring node to be installed with mathjaxnode or
	# unpackaged katex.
	rm -f test/testcases/span/math/{katex,mathjaxnode}* \
	   test/testcases/block/15_math/{katex,mathjaxnode}* || die
}
