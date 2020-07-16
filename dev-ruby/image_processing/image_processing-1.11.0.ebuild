# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md doc/*.md"

RUBY_FAKEGEM_GEMSPEC="image_processing.gemspec"

inherit ruby-fakegem

DESCRIPTION="High-level image processing helper methods with libvips and ImageMagick"
HOMEPAGE="https://github.com/janko/image_processing"
SRC_URI="https://github.com/janko/image_processing/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND+=" test? ( media-gfx/imagemagick[jpeg,tiff] )"

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
	rm -f test/{pipeline,vips}_test.rb || die
	sed -i -e '/assert_dimensions/ s:^:#:' test/*_test.rb || die

	# phash is not packaged
	sed -i -e '/\(assert\|refute\)_similar/ s:^:#:' test/*_test.rb || die

	sed -i -e '/\(bundler\|phashion\|vips\)/ s:^:#:' Rakefile test/test_helper.rb || die
}
