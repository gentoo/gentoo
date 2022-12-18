# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_GEMSPEC=rr.gemspec

inherit ruby-fakegem

DESCRIPTION="A double framework featuring a selection of double techniques and a terse syntax"
HOMEPAGE="https://rr.github.io/rr"
SRC_URI="https://github.com/rr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? (
		dev-ruby/minitest
		dev-ruby/diff-lcs
		dev-ruby/test-unit-rr )"

all_ruby_prepare() {
	rm Gemfile || die
}
