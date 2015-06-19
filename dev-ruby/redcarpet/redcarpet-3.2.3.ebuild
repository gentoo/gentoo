# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/redcarpet/redcarpet-3.2.3.ebuild,v 1.2 2015/05/22 08:42:15 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOCS="README.markdown CONTRIBUTING.md CHANGELOG.md doc"
RUBY_FAKEGEM_TASK_TEST="test:unit"
inherit multilib ruby-fakegem

SRC_URI="https://github.com/vmg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A Ruby wrapper for Upskirt"
HOMEPAGE="https://github.com/vmg/redcarpet"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/nokogiri )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e 's/=> :compile//'  Rakefile || die
	rm test/benchmark.rb

	# Avoid broken tests that should use render_with instead.
	sed -i -e '/no_rewind_into_previous_inline/,/^  end/ s:^:#:' test/markdown_test.rb || die

	# Avoid unneeded dependency on rake-compiler
	sed -i -e '/extensiontask/I s:^:#:' Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext/redcarpet extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/${PN}
	cp ext/${PN}/*$(get_modname) lib || die
}
