# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_RECIPE_DOC="rake"
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A template language aiming to reduce the syntax to the essential parts"
HOMEPAGE="https://slim-template.github.io/"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~riscv ~x86"
IUSE="doc"

ruby_add_rdepend "
	!dev-ruby/slim:5
	>=dev-ruby/tilt-2.1.0:*
	>=dev-ruby/temple-0.10.0:0.7
"
# sass tests are currently disabled: https://github.com/slim-template/slim/commit/bd9d4601cd8142aa9fdbc0d87c9f9132a9a56cda
ruby_add_bdepend "
	doc? (
		dev-ruby/yard
		dev-ruby/redcarpet
	)
	test? (
		dev-ruby/minitest:5
		dev-ruby/kramdown:2
		dev-ruby/redcarpet
		>=dev-ruby/test-unit-3.5
	)
"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die

	# This sinatra code expects tests to be installed but we strip those.
	sed -i -e "s/require 'sinatra'/require 'bogussinatra'/" Rakefile || die

	# Add missing include, bug 816573
	sed -i -e "1irequire 'ostruct'" test/core/test_code_evaluation.rb || die

	# Avoid tests for things we don't have. The builder test does not pass with tilt 2.x
	sed -i -e '/test_wip_render_with_asciidoc/,/^  end/ s:^:#:' \
		-e '/test_render_with_wiki/,/^  end/ s:^:#:' \
		-e '/test_render_with_creole/,/^  end/ s:^:#:' \
		-e '/test_render_with_builder/,/^  end/ s:^:#:' \
		-e '/test_render_with_org/,/^  end/ s:^:#:' test/core/test_embedded_engines.rb || die

	# Avoid test failing due to tilt providing yet another markdown implementation
	sed -i -e '/test_render_with_markdown/askip "new tilt version"' test/core/test_embedded_engines.rb || die
	sed -i -e '/test_no_translation_of_embedded/askip "new tilt version"' test/translator/test_translator.rb || die

	sed -i -e '/s\.files/ s/git ls-files/find . -type f -print/' \
		-e '/s\.executables/ s:git ls-files -- bin/\*:find bin -type f -print:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	sed -i -e '/Open3/ s:ruby:'${RUBY}':' test/core/test_commands.rb || die
}
