# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOCS="README.markdown CONTRIBUTING.md CHANGELOG.md doc"
RUBY_FAKEGEM_TASK_TEST="test:unit"

RUBY_FAKEGEM_GEMSPEC="redcarpet.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/redcarpet/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="A Ruby wrapper for Upskirt"
HOMEPAGE="https://github.com/vmg/redcarpet"
SRC_URI="https://github.com/vmg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e 's/=> :compile//'  Rakefile || die

	# Avoid unneeded dependency on rake-compiler
	sed -i -e '/extensiontask/I s:^:#:' Rakefile || die
}

each_ruby_prepare() {
	sed -i -e "s#ruby#${RUBY}#" bin/redcarpet || die
}
