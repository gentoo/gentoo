# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem eutils

DESCRIPTION="Manipulate images with minimal use of memory"
HOMEPAGE="https://github.com/minimagick/minimagick"
SRC_URI="https://github.com/minimagick/minimagick/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="minimagick-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

# It's only used at runtime in this case because this extension only
# _calls_ the commands. But when we run tests we're going to need tiff
# and jpeg support at a minimum.
RDEPEND+=" media-gfx/imagemagick"
DEPEND+=" test? ( virtual/imagemagick-tools[jpeg,png,tiff] )"

ruby_add_bdepend "test? ( dev-ruby/mocha dev-ruby/posix-spawn dev-ruby/webmock )"

all_ruby_prepare() {
	# remove executable bit from all files
	find "${S}" -type f -exec chmod -x {} +

	sed -i -e '/\([Bb]undler\|pry\)/ s:^:#:' spec/spec_helper.rb || die

	# Don't force a specific formatter but use overall Gentoo defaults.
	sed -i -e '/config.formatter/d' spec/spec_helper.rb || die

	# Avoid broken spec that does not assume . in path name
	sed -i -e '/reformats a layer/,/end/ s:^:#:' spec/lib/mini_magick/image_spec.rb || die

	# Avoid spec broken by recent imagemagick updates
	sed -i -e '/cache files generated from .mpc/askip' spec/lib/mini_magick/image_spec.rb || die
	sed -i -e '/does not hang when parsing verbose data/askip' spec/lib/mini_magick/image_spec.rb || die

	# Avoid graphicsmagick tests because installing both in parallel for
	# tests is hard.
	sed -i -e 's/:graphicsmagick//' spec/spec_helper.rb || die
	sed -i -e '/identifies when gm exists/,/^    end/ s:^:#:' spec/lib/mini_magick/utilities_spec.rb || die
	sed -i -e '/returns GraphicsMagick/,/^    end/ s:^:#:' spec/lib/mini_magick_spec.rb || die
}
