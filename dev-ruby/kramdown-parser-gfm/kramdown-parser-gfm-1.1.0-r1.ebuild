# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

inherit edo ruby-fakegem

DESCRIPTION="A kramdown parser for the GFM dialect of Markdown"
HOMEPAGE="https://github.com/kramdown/parser-gfm"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="doc"

ruby_add_rdepend "dev-ruby/kramdown:2"
ruby_add_bdepend "test? ( dev-ruby/kramdown[latex] )"

all_ruby_prepare() {
	# Avoid testcase which is no longer compatible with newer rouge
	rm -f test/testcases/codeblock_fenced.text || die

	# Avoid test broken with current kramdown versions
	rm -r test/testcases/header_ids.text || die
}

each_ruby_test() {
	edo ${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
