# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="changelog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Simple Hash extension to make working with nested hashes easier"
HOMEPAGE="https://github.com/liufengyun/hashdiff"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
}
