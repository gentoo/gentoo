# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A Ruby port of the SmartyPants PHP library"
HOMEPAGE="http://chneukirchen.org/repos/rubypants/README"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/ecov/I s:^:#:' test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -I. test/rubypants_test.rb || die "tests failed"
}
