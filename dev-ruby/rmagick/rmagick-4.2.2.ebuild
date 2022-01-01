# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="rmagick.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/RMagick/extconf.rb)

MY_PV=RMagick_${PV//\./-}

inherit multilib ruby-fakegem

DESCRIPTION="An interface between Ruby and the ImageMagick(TM) image processing library"
HOMEPAGE="https://github.com/rmagick/rmagick"
SRC_URI="https://github.com/rmagick/rmagick/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="rmagick-${MY_PV}"

LICENSE="Artistic"
SLOT="4"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND+=" >=media-gfx/imagemagick-6.9.0:="
DEPEND+=" test? ( >=media-gfx/imagemagick-7.1.0:=[jpeg,lqr,webp] )"

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

	# Update version number hardcoded in tests
	sed -i -e 's/"7.0"/"7.1"/' spec/rmagick/image/channel_mean_spec.rb || die

	# Create directory used for a test
	mkdir tmp
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
