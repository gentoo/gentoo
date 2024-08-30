# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="changelog.md README.md"
RUBY_FAKEGEM_GEMSPEC="hashdiff.gemspec"

inherit ruby-fakegem

DESCRIPTION="Simple Hash extension to make working with nested hashes easier"
HOMEPAGE="https://github.com/liufengyun/hashdiff"
SRC_URI="https://github.com/liufengyun/hashdiff/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e '/test_files/ s:^:#:' \
		-e 's/git ls-files/find * -print/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die

	sed -i -e 's/1.1.0/1.1.1/' lib/hashdiff/version.rb || die
}
