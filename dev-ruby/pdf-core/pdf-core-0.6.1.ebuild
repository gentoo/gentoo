# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Implements low level PDF features for Prawn"
HOMEPAGE="https://github.com/prawnpdf/pdf-core/"

LICENSE="|| ( Ruby GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? ( =dev-ruby/pdf-inspector-1.1*
	>=dev-ruby/pdf-reader-1.2 =dev-ruby/pdf-reader-1* )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" spec/spec_helper.rb || die
}
