# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md doc/*.md"

RUBY_FAKEGEM_GEMSPEC="image_processing.gemspec"

inherit ruby-fakegem

DESCRIPTION="High-level image processing helper methods with libvips and ImageMagick"
HOMEPAGE="https://github.com/janko/image_processing"
SRC_URI="https://github.com/janko/image_processing/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND+=" test? ( media-gfx/imagemagick[jpeg,png,tiff,xml] )"

ruby_add_rdepend "
	>=dev-ruby/mini_magick-4.9.5:0
"

ruby_add_bdepend "test? (
	>=dev-ruby/minitest-5.8:5
	>=dev-ruby/minitest-hooks-1.4.2
	dev-ruby/minispec-metadata
)"

all_ruby_prepare() {
	# Only support imagemagick for now since vips is not packaged
	sed -i -e '/ruby-vips/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
	rm -f test/{builder,pipeline,vips}_test.rb || die
	sed -i -e '/assert_dimensions/ s:^:#:' test/*_test.rb || die

	# phash is not packaged
	sed -i -e '/\(assert\|refute\)_similar/ s:^:#:' test/*_test.rb || die

	sed -i -e '/\(bundler\|phashion\|vips\)/ s:^:#:' Rakefile test/test_helper.rb || die
}
