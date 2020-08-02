# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="diva.gemspec"

inherit ruby-fakegem

DESCRIPTION="Implementation of expression for handling things."
HOMEPAGE="https://github.com/toshia/diva https://rubygems.org/gems/diva"
SRC_URI="https://github.com/toshia/diva/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "<dev-ruby/addressable-2.8"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e 's/git ls-files -z/find -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
