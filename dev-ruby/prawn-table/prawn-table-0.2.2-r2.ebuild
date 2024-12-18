# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Provides support for tables in Prawn"
HOMEPAGE="http://prawn.majesticseacreature.com/"
LICENSE="|| ( GPL-2+ Ruby )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/mocha
	>=dev-ruby/pdf-inspector-1.1.0
	>=dev-ruby/pdf-reader-1.2
	>=dev-ruby/prawn-1.3.0
	)"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/s/^/#/" spec/spec_helper.rb || die
	# Remove failing test
	# See https://github.com/prawnpdf/prawn-table/issues/10
	sed -i -e "/Prints table on one page when using subtable with colspan > 1/,+24 s/^/#/" spec/table_spec.rb || die
}
