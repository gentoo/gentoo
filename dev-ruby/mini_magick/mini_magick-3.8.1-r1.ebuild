# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mini_magick/mini_magick-3.8.1-r1.ebuild,v 1.1 2014/11/08 16:20:14 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem eutils

DESCRIPTION="Manipulate images with minimal use of memory"
HOMEPAGE="http://github.com/minimagick/minimagick"
SRC_URI="https://github.com/minimagick/minimagick/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="minimagick-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# It's only used at runtime in this case because this extension only
# _calls_ the commands. But when we run tests we're going to need tiff
# and jpeg support at a minimum.
RDEPEND="media-gfx/imagemagick"
DEPEND="test? ( media-gfx/imagemagick[tiff,jpeg] )"

ruby_add_rdepend ">=dev-ruby/subexec-0.2.1 =dev-ruby/subexec-0.2*"

ruby_add_bdepend "test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	# remove executable bit from all files
	find "${S}" -type f -exec chmod -x {} +

	sed -i -e '/[Bb]undler/ s:^:#:' spec/spec_helper.rb || die

	# Don't force a specific formatter but use overall Gentoo defaults.
	sed -i -e '/config.formatter/d' spec/spec_helper.rb || die

	# Avoid test depending on graphicsmagick
	sed -e '/identifies when gm exists/,/^    end/ s:^:#:' \
		-i spec/lib/mini_magick_spec.rb || die
}
