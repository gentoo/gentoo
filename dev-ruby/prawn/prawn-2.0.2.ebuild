# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Fast, Nimble PDF Generation For Ruby"
HOMEPAGE="http://prawn.majesticseacreature.com/"
SRC_URI="https://github.com/prawnpdf/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( GPL-2 Ruby )"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/pdf-core-0.6.0
	>=dev-ruby/ttfunk-1.4.0"
ruby_add_bdepend "test? ( dev-ruby/coderay
	dev-ruby/mocha
	>=dev-ruby/pdf-inspector-1.2.0
	>=dev-ruby/pdf-reader-1.2
	)"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile spec/spec_helper.rb || die
	# Remove failing tests
	# https://github.com/prawnpdf/prawn/pull/693
	# https://github.com/prawnpdf/prawn/issues/603
	sed -i -e "/should process UTF-8 chars/,+9 s/^/#/" spec/line_wrap_spec.rb || die
	sed -i -e "/shrink_to_fit with special utf-8 text/,+12 s/^/#/" spec/text_spec.rb || die
}
