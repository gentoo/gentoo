# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.textile"

inherit multilib ruby-fakegem

DESCRIPTION="An interface between Ruby and the ImageMagick(TM) image processing library"
HOMEPAGE="https://github.com/gemhome/rmagick"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~x86-macos"
IUSE="doc"

# Since 2.13.3 rmagick now supports HDRI enabled, but with it enabled
# tests fail with segmentation faults.
RDEPEND+=" >=media-gfx/imagemagick-6.4.9:=[-hdri]"
DEPEND+=" >=media-gfx/imagemagick-6.4.9:=[-hdri]"

all_ruby_prepare() {
	# Avoid unused dependency on rake-compiler. This also avoids an
	# extra compile during tests.
	sed -i -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/end/ s:^:#:' \
		-e '/compile/ s:^:#:' Rakefile || die

	# Squelch harmless warning about imagemagick installation.
	sed -i -e '/prefix/ s:ImageMagick:ImageMagick-6:' ext/RMagick/extconf.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/RMagick extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -Cext/RMagick V=1
	cp ext/RMagick/RMagick2$(get_modname) lib/ || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*

	if use doc ; then
		dohtml -r doc
	fi
}
