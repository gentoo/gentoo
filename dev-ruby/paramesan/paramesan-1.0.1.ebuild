# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="paramesan.gemspec"

inherit ruby-fakegem

DESCRIPTION="Parameterized tests in Ruby"
HOMEPAGE="https://github.com/jpace/paramesan"

SRC_URI="https://github.com/jpace/paramesan/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}
