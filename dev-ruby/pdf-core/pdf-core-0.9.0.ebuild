# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Implements low level PDF features for Prawn"
HOMEPAGE="https://github.com/prawnpdf/pdf-core/"
SRC_URI="https://github.com/prawnpdf/pdf-core/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? ( =dev-ruby/pdf-inspector-1*
	>=dev-ruby/pdf-reader-1.2 =dev-ruby/pdf-reader-1* )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" spec/spec_helper.rb || die
}
