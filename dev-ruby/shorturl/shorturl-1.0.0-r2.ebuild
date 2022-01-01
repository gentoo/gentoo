# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_TASK_DOC="doc"

RUBY_FAKEGEM_EXTRADOC="ChangeLog.txt README.rdoc TODO.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="A very simple library to use URL shortening services such as TinyURL or RubyURL"
HOMEPAGE="https://github.com/robbyrussell/shorturl/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-macos"
IUSE=""

# All tests require network connectivity.
RESTRICT="test"

each_ruby_test() {
	${RUBY} -Ilib:test test/ts_all.rb || die "tests failed"
}

all_ruby_install() {
	all_fakegem_install

	if use doc; then
		# If the doc build fails, the doc directory might not exist
		pushd doc &>/dev/null || die "pushd doc failed"
		dohtml -r .
		popd &>/dev/null
	fi
}
