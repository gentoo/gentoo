# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

inherit ruby-fakegem

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"
DESCRIPTION="Removes leading whitespace from Ruby heredocs"
HOMEPAGE="https://github.com/adrianomitre/heredoc_unindent"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86 ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

ruby_add_bdepend "test? ( >=dev-ruby/hoe-2.8.0 dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -i -e '1igem "test-unit"' test/test_heredoc_unindent.rb || die
}
