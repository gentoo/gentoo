# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="metaclass.gemspec"

inherit ruby-fakegem

DESCRIPTION="Adds a __metaclass__ method to all Ruby objects"
HOMEPAGE="https://github.com/floehopper/metaclass"
SRC_URI="https://github.com/floehopper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/test_helper.rb || die
	sed -i -e 's/git ls-files/find */' -e '/\(test_files\|executables\)/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
