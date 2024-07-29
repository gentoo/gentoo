# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="rmagick.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/RMagick/extconf.rb)

MY_PV=RMagick_${PV//\./-}

inherit ruby-fakegem

DESCRIPTION="An interface between Ruby and the ImageMagick(TM) image processing library"
HOMEPAGE="https://github.com/rmagick/rmagick"
SRC_URI="https://github.com/rmagick/rmagick/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="rmagick-${MY_PV}"

LICENSE="Artistic"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND+=" >=media-gfx/imagemagick-6.9.0:="
DEPEND+=" >=media-gfx/imagemagick-6.9.0 test? ( >=media-gfx/imagemagick-7.1.0:=[jpeg,lqr,lcms,postscript,tiff,webp,xml] media-fonts/dejavu )"

# observer is a default gem packaged with ruby

ruby_add_bdepend "dev-ruby/pkg-config"

all_ruby_prepare() {
	# Avoid unused dependency on rake-compiler. This also avoids an
	# extra compile during tests.
	sed -i -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/end/ s:^:#:' \
		-e '/compile/ s:^:#:' Rakefile || die
	sed -i -e '/pry/ s:^:#:' -e '5irequire "tempfile"' spec/spec_helper.rb || die
	sed -e 's/git ls-files/find */' \
		-e '/pkg-config/ s:^:#:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Squelch harmless warning about imagemagick installation.
	sed -i -e '/prefix/ s:ImageMagick:ImageMagick-6:' ext/RMagick/extconf.rb || die

	# Create directory used for a test
	mkdir tmp
}

each_ruby_test() {
	# Borrowed from media-gfx/gscan2pdf
	# Needed to avoid test failures on e.g. ppc, bug #815856
	# (Unclear why it doesn't manifest on amd64 here at least)
	local confdir="${HOME}/.config/ImageMagick"
	mkdir -p "${confdir}" || die
	cat > "${confdir}/policy.xml" <<-EOT || die
		<policymap>
			<policy domain="coder" rights="read|write" pattern="PDF" />
			<policy domain="coder" rights="read" pattern="PS" />
		</policymap>
	EOT

	RSPEC_VERSION="3" ruby-ng_rspec
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
