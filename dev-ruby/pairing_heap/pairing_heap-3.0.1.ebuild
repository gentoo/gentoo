# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="pairing_heap.gemspec"

inherit ruby-fakegem

DESCRIPTION="Performant priority queue with support for changing priority"
HOMEPAGE="https://github.com/mhib/pairing_heap"
SRC_URI="https://github.com/mhib/pairing_heap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/require.*\(bundler\|standard\)/ s:^:#:' Rakefile || die

	sed -e 's:_relative ": "./:' \
		-e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
