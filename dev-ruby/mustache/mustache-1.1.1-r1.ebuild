# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC="man:build"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit multilib ruby-fakegem

DESCRIPTION="Mustache is a framework-agnostic way to render logic-free views"
HOMEPAGE="https://mustache.github.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-test-ordering.patch" )

ruby_add_bdepend "doc? ( app-text/ronn-ng )"

all_ruby_prepare() {
	# Fix for renamed .ron files
	sed -i -e 's:\.ronn:.ron:' Rakefile || die

	sed -i -e '/simplecov/,/^end/ s:^:#:' test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['test/*.rb'].each{|f| require f}" || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/mustache.1 man/mustache.5
}
