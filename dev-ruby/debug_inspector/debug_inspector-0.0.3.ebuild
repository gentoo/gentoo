# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Ruby wrapper for the MRI 2.0 debug_inspector API"
HOMEPAGE="https://github.com/banister/debug_inspector"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/${PN}
	cp ext/${PN}/${PN}.so lib/ || die
}
