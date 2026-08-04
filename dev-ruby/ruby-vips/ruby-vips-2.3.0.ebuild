# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="ruby-vips.gemspec"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A fast image processing library with low memory needs"
HOMEPAGE="https://github.com/libvips/ruby-vips"
SRC_URI="
	https://github.com/libvips/ruby-vips/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# See 'ffi_lib FFI.library_name("vips", ??)' in lib/vips.rb
VIPS_ABI="42"

RDEPEND="
	media-libs/vips:0/${VIPS_ABI}[introspection]
"

ruby_add_rdepend "
	>=dev-ruby/ffi-1.12
	dev-ruby/logger
"

all_ruby_prepare() {
	sed -e 's:require_relative ":require "./:' \
		-e 's:git ls-files -z:find * -print0:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
