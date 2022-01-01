# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

inherit ruby-fakegem

DESCRIPTION="A kramdown parser for the GFM dialect of Markdown"
HOMEPAGE="https://github.com/kramdown/parser-gfm"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"
IUSE="doc"

ruby_add_rdepend "dev-ruby/kramdown:2"

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
