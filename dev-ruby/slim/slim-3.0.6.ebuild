# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_TASK_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="A template language whose goal is reduce the syntax to the essential parts without becoming cryptic"
HOMEPAGE="http://slim-lang.com/"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE="doc"

ruby_add_rdepend ">=dev-ruby/tilt-1.3.3:* <dev-ruby/tilt-2.1:*
	>=dev-ruby/temple-0.7.3:0.7"

ruby_add_bdepend "doc? ( dev-ruby/yard dev-ruby/redcarpet )"

ruby_add_bdepend "test? ( dev-ruby/sass )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die

	# This sinatra code expects tests to be installed but we strip those.
	sed -i -e "s/require 'sinatra'/require 'bogussinatra'/" Rakefile || die

	# Avoid tests for things we don't have.
	sed -i -e '/test_wip_render_with_asciidoc/,/^  end/ s:^:#:' \
		-e '/test_render_with_wiki/,/^  end/ s:^:#:' \
		-e '/test_render_with_creole/,/^  end/ s:^:#:' \
		-e '/test_render_with_org/,/^  end/ s:^:#:' test/core/test_embedded_engines.rb || die
}

each_ruby_prepare() {
	sed -i -e '/Open3/ s:ruby:'${RUBY}':' test/core/test_commands.rb || die
}
