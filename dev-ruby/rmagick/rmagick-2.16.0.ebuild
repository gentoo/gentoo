# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.textile"

inherit multilib ruby-fakegem

DESCRIPTION="An interface between Ruby and the ImageMagick(TM) image processing library"
HOMEPAGE="https://github.com/gemhome/rmagick"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-macos"
IUSE="doc"

RDEPEND+=" >=media-gfx/imagemagick-6.4.9:="
DEPEND+=" >=media-gfx/imagemagick-6.4.9:=[jpeg]"

ruby_add_bdepend "test? ( dev-ruby/rspec:3 )"

all_ruby_prepare() {
	# Avoid unused dependency on rake-compiler. This also avoids an
	# extra compile during tests.
	sed -i -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/end/ s:^:#:' \
		-e '/compile/ s:^:#:' Rakefile || die

	# Avoid simplecov dependency
	sed -i -e '/simplecov/ s:^:#:' Rakefile test/test_all_basic.rb || die

	# Squelch harmless warning about imagemagick installation.
	sed -i -e '/prefix/ s:ImageMagick:ImageMagick-6:' ext/RMagick/extconf.rb || die

	# Avoid some tests that seem to be very dependent on specific
	# imagemagick versions. color defs?
	sed -i -e '/test_\(gray\|compress_colormap\)/,/^  end/ s:^:#:' test/Image2.rb || die
	sed -i -e '/test_optimize_layers/,/^  end/ s:^:#:' test/ImageList2.rb || die
	sed -i -e '/test_\(background_color\|border_color\|image_type\)/,/^  end/ s:^:#:' test/Image_attributes.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/RMagick extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -Cext/RMagick V=1
	cp ext/RMagick/RMagick2$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -S rake test || die
	RSPEC_VERSION=3 ruby-ng_rspec spec || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*

	if use doc ; then
		dohtml -r doc
	fi
}
