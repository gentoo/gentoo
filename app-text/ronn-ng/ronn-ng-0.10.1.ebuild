# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="AUTHORS CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="ronn-ng.gemspec"

inherit ruby-fakegem

DESCRIPTION="Builds manuals in HTML and Unix man page format from Markdown"
HOMEPAGE="https://github.com/apjanke/ronn-ng"
SRC_URI="https://github.com/apjanke/ronn-ng/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND+="!app-text/ronn"

DEPS="
	>=dev-ruby/kramdown-2.1:2
	>=dev-ruby/kramdown-parser-gfm-1.0.1:1
	>=dev-ruby/nokogiri-1.14.3:0
"

ruby_add_rdepend "
	=dev-ruby/mustache-1*
	${DEPS}
"

ruby_add_bdepend "${DEPS}"

all_ruby_prepare() {
	# Avoid tests with code blocks that are fragile for e.g. presence /
	# absence of a source highlighter.
	rm -f test/code_blocks*.ro{ff,nn} || die
}

each_ruby_prepare() {
	# Make sure that we always use the right interpreter during tests
	sed -i -e "/output/ s:ronn:${RUBY} bin/ronn:" test/test_ronn.rb || die
	# ... and during the man page build.
	sed -i -e "/sh 'ronn/s:ronn:${RUBY} bin/ronn:" Rakefile || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/ronn.1 man/ronn-format.7
}
