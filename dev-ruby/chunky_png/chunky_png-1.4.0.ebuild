# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""

RUBY_FAKEGEM_EXTRADOC="BENCHMARKING.rdoc CHANGELOG.rdoc README.md"

RUBY_FAKEGEM_BINWRAP=""

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
