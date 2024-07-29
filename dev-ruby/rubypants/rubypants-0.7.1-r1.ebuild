# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A Ruby port of the SmartyPants PHP library"
HOMEPAGE="https://leahneukirchen.org/repos/rubypants/README"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/ecov/I s:^:#:' test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -I. test/rubypants_test.rb || die "tests failed"
}
