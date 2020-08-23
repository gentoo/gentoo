# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="rmagick.gemspec"

MY_PV=RMagick_${PV//\./-}

inherit multilib ruby-fakegem

DESCRIPTION="An interface between Ruby and the ImageMagick(TM) image processing library"
HOMEPAGE="https://github.com/rmagick/rmagick"
SRC_URI="https://github.com/rmagick/rmagick/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="rmagick-${MY_PV}"

LICENSE="Artistic"
SLOT="4"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-macos"
IUSE="doc"

RDEPEND+=" >=media-gfx/imagemagick-6.9.0:="
DEPEND+=" test? ( >=media-gfx/imagemagick-6.9.0:=[jpeg,webp] )"

all_ruby_prepare() {
	# Avoid unused dependency on rake-compiler. This also avoids an
	# extra compile during tests.
	sed -i -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/end/ s:^:#:' \
		-e '/compile/ s:^:#:' Rakefile || die
	sed -i -e '/pry/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's/git ls-files/find/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Squelch harmless warning about imagemagick installation.
	sed -i -e '/prefix/ s:ImageMagick:ImageMagick-6:' ext/RMagick/extconf.rb || die

	# Reading PDFs is not allowed by the default Gentoo security policy for imagemagick
	sed -i -e '/can read PDF file/askip "Not allowed by Gentoo security policy"' spec/rmagick/image/read_spec.rb || die
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
		docinto .
		dodoc -r doc
	fi
}
