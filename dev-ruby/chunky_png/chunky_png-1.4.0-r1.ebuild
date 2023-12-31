# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""

RUBY_FAKEGEM_EXTRADOC="BENCHMARKING.rdoc CHANGELOG.rdoc README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="chunky_png.gemspec"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby library that can read and write PNG images"
HOMEPAGE="https://github.com/wvanbergen/chunky_png"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-ruby32.patch"
)

all_ruby_prepare() {
	sed -i -e '/[bB]undler/s:^:#:' {spec,benchmarks}/*.rb || die
	rm Gemfile* || die

	# Avoid git dependency
	sed -i -e '/s.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}
