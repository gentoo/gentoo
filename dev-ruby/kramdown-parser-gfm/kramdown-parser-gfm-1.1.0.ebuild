# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

inherit ruby-fakegem

DESCRIPTION="A kramdown parser for the GFM dialect of Markdown"
HOMEPAGE="https://github.com/kramdown/parser-gfm"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm64"
SLOT="$(ver_cut 1)"
IUSE="doc"

ruby_add_rdepend "dev-ruby/kramdown:2"
ruby_add_bdepend "test? ( dev-ruby/kramdown[latex] )"

all_ruby_prepare() {
	# Avoid testcase which is no longer compatible with newer rouge
	rm -f test/testcases/codeblock_fenced.text || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
