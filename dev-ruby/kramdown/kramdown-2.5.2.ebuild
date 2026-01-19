# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md AUTHORS CONTRIBUTERS"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Yet-another-markdown-parser but fast, pure Ruby, using strict syntax definition"
HOMEPAGE="https://kramdown.gettalong.org/"

LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos"
IUSE="latex unicode"

LATEX_DEPS="latex? ( dev-texlive/texlive-latex dev-texlive/texlive-latexextra )"
RDEPEND="${LATEX_DEPS}"
DEPEND="test? (
	${LATEX_DEPS}
	>=app-text/htmltidy-5.0.0
)"

ruby_add_rdepend "
	>=dev-ruby/rexml-3.4.4
	>=dev-ruby/rouge-3.26.0:2
	unicode? ( >=dev-ruby/stringex-1.5.1 )
"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )
	test? ( >=dev-ruby/minitest-5.0 )"

all_ruby_prepare() {
	if use latex; then
		# https://github.com/gettalong/kramdown/issues/820
		sed -e "/EXCLUDE_LATEX_FILES =/a'test/testcases/block/14_table/table_with_footnote.text'," \
			-i test/test_files.rb || die
	else
		# Remove latex tests. They will fail gracefully when latex isn't
		# present at all, but not when components are missing (most
		# notable ucs.sty).
		sed -i -e '/latex -v/,/^  end/ s:^:#:' test/test_files.rb || die
	fi

	if ! use unicode; then
		rm -f test/testcases/block/04_header/with_auto_ids.* || die
	fi
}

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/man1/kramdown.1
}
