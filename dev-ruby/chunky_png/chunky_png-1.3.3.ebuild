# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""

RUBY_FAKEGEM_EXTRADOC="BENCHMARKING.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="chunky_png.gemspec"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby library that can read and write PNG images"
HOMEPAGE="https://wiki.github.com/wvanbergen/chunky_png"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/[bB]undler/s:^:#:' {spec,benchmarks}/*.rb || die
	rm Gemfile* || die

	# Avoid git dependency
	sed -i -e '/s.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}
