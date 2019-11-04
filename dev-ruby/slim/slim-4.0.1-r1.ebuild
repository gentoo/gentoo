# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit eapi7-ver ruby-fakegem

DESCRIPTION="A template language aiming to reduce the syntax to the essential parts"
HOMEPAGE="http://slim-lang.com/"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
SLOT="$(ver_cut 1)"
IUSE="doc"

ruby_add_rdepend ">=dev-ruby/tilt-2.0.6:* =dev-ruby/tilt-2.0*:*
	>=dev-ruby/temple-0.7.6:0.7
	!!<dev-ruby/slim-3.0.9-r1"

ruby_add_bdepend "doc? ( dev-ruby/yard dev-ruby/redcarpet )"

ruby_add_bdepend "test? ( dev-ruby/redcarpet dev-ruby/sass )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die

	# This sinatra code expects tests to be installed but we strip those.
	sed -i -e "s/require 'sinatra'/require 'bogussinatra'/" Rakefile || die

	# Avoid tests for things we don't have. The builder test does not pass with tilt 2.x
	sed -i -e '/test_wip_render_with_asciidoc/,/^  end/ s:^:#:' \
		-e '/test_render_with_wiki/,/^  end/ s:^:#:' \
		-e '/test_render_with_creole/,/^  end/ s:^:#:' \
		-e '/test_render_with_builder/,/^  end/ s:^:#:' \
		-e '/test_render_with_org/,/^  end/ s:^:#:' test/core/test_embedded_engines.rb || die

	sed -i -e '/s\.files/ s/git ls-files/find . -type f -print/' \
		-e '/s\.executables/ s:git ls-files -- bin/\*:find bin -type f -print:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	sed -i -e '/Open3/ s:ruby:'${RUBY}':' test/core/test_commands.rb || die
}
