# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="An XML toolkit for Ruby"
HOMEPAGE="https://github.com/ruby/rexml"
SRC_URI="https://github.com/ruby/rexml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
SLOT="3"

all_ruby_prepare() {
	sed -i -e 's:require_relative ":require "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}
