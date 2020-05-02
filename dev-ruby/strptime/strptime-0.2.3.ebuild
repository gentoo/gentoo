# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="strptime.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit multilib ruby-fakegem

DESCRIPTION="A fast strptime/strftime engine which uses VM"
HOMEPAGE="https://github.com/nurse/strptime"
SRC_URI="https://github.com/nurse/strptime/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_configure() {
	${RUBY} -Cext/strptime extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/strptime V=1
	cp ext/strptime/strptime$(get_modname) lib/strptime/ || die
}
