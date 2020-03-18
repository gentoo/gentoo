# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Ruby bindings for Tokyo Cabinet"
HOMEPAGE="http://fallabs.com/tokyocabinet/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""

RDEPEND+="dev-db/tokyocabinet"

each_ruby_configure() {
	${RUBY} extconf.rb || die
}

each_ruby_compile() {
	emake V=1
}

each_ruby_install() {
	emake install DESTDIR="${D}"

	each_fakegem_install
}
