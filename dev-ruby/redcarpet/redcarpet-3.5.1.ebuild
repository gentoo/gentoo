# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOCS="README.markdown CONTRIBUTING.md CHANGELOG.md doc"
RUBY_FAKEGEM_TASK_TEST="test:unit"

RUBY_FAKEGEM_GEMSPEC="redcarpet.gemspec"

inherit multilib ruby-fakegem

SRC_URI="https://github.com/vmg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A Ruby wrapper for Upskirt"
HOMEPAGE="https://github.com/vmg/redcarpet"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e 's/=> :compile//'  Rakefile || die

	# Avoid unneeded dependency on rake-compiler
	sed -i -e '/extensiontask/I s:^:#:' Rakefile || die
}

each_ruby_prepare() {
	sed -i -e "s#ruby#${RUBY}#" bin/redcarpet || die
}

each_ruby_configure() {
	${RUBY} -Cext/redcarpet extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/${PN}
	cp ext/${PN}/*$(get_modname) lib || die
}
