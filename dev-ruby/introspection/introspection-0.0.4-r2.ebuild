# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

# No documentation task
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Dynamic inspection of the hierarchy of method definitions on a Ruby object"
HOMEPAGE="https://jamesmead.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/metaclass-0.0.1"

ruby_add_bdepend "test? ( dev-ruby/blankslate )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile test/test_helper.rb || die
}
