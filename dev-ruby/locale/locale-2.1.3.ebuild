# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc/reference"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc doc/text/news.md"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_GEMSPEC="locale.gemspec"

inherit ruby-fakegem

DESCRIPTION="A pure ruby library which provides basic APIs for localization"
HOMEPAGE="https://github.com/ruby-gettext/locale"
LICENSE="|| ( Ruby GPL-2 )"
SRC_URI="https://github.com/ruby-gettext/locale/archive/${PV}.tar.gz -> ${P}-git.tgz"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/yard )"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 dev-ruby/test-unit-rr )"

all_ruby_prepare() {
	sed -i -e '/notify/ s:^:#:' test/run-test.rb || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc ; then
		yard || die
	fi
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r samples
}
