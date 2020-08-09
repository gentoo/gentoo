# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README"

inherit multilib ruby-fakegem

DESCRIPTION="Levenshtein distance algorithm"
HOMEPAGE="https://github.com/mbleigh/mash"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cext/levenshtein extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/levenshtein V=1
	cp ext/levenshtein/levenshtein_fast$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib test/test.rb || die
}
