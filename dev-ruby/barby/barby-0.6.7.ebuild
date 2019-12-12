# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby barcode generator that doesn't rely on 3rd party libraries"
HOMEPAGE="http://toreto.re/barby/"

GITHUB_USER="toretore"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test qrcode rmagick prawn png cairo"

ruby_add_rdepend "
	rmagick? ( dev-ruby/rmagick )
	cairo? ( dev-ruby/rcairo )"

ruby_add_rdepend "qrcode? ( dev-ruby/rqrcode )
	png? ( dev-ruby/chunky_png )
	prawn? ( dev-ruby/prawn:* )"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

# testing requires imagemagick capable of png output
DEPEND+=" test? ( media-gfx/imagemagick[png] )"

# prawn breaks tests for some reasons, needs to be investigated; code
# still works though.
RESTRICT+=" prawn? ( test )"

all_ruby_prepare() {
	sed -i -e 's/README/README.md/' Rakefile || die

	sed -i -e '/[bB]undler/s:^:#:' test/test_helper.rb || die

	if use qrcode; then
		sed -i -e '/^end/i s.add_dependency "rqrcode"' ${RUBY_FAKEGEM_GEMSPEC}
	else
		rm \
			lib/barby/barcode/qr_code.rb \
			test/qr_code_test.rb
	fi

	if use rmagick; then
		sed -i -e '/^end/i s.add_dependency "rmagick"' ${RUBY_FAKEGEM_GEMSPEC}
	else
		rm \
			lib/barby/outputter/rmagick_outputter.rb \
			test/outputter/rmagick_outputter_test.rb
	fi

	if use prawn; then
		sed -i -e '/^end/i s.add_dependency "prawn"' ${RUBY_FAKEGEM_GEMSPEC}
	else
		rm \
			lib/barby/outputter/prawn_outputter.rb \
			test/outputter/prawn_outputter_test.rb
	fi

	if use png; then
		sed -i -e '/^end/i s.add_dependency "chunky_png"' ${RUBY_FAKEGEM_GEMSPEC}
	else
		rm \
			lib/barby/outputter/png_outputter.rb \
			test/outputter/png_outputter_test.rb
	fi

	if use cairo; then
		sed -i -e '/^end/i s.add_dependency "cairo"' ${RUBY_FAKEGEM_GEMSPEC}
	else
		rm \
			lib/barby/outputter/cairo_outputter.rb \
			test/outputter/cairo_outputter_test.rb
	fi

	rm -f \
		lib/barby/barcode/data_matrix.rb \
		test/data_matrix_test.rb \
		lib/barby/outputter/pdfwriter_outputter.rb \
		test/outputter/pdfwriter_outputter_test.rb || die

	sed -i \
		-e '/semacode/d' \
		-e '/pdf-writer/d' \
		${RUBY_FAKEGEM_GEMSPEC} || die
}
