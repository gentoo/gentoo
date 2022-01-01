# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Fast, Nimble PDF Generation For Ruby"
HOMEPAGE="http://prawn.majesticseacreature.com/"
SRC_URI="https://github.com/prawnpdf/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( GPL-2 Ruby )"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_rdepend "=dev-ruby/pdf-core-0.7*
	>=dev-ruby/ttfunk-1.5:*"
ruby_add_bdepend "test? ( dev-ruby/coderay
	>=dev-ruby/pdf-inspector-1.2.1
	>=dev-ruby/pdf-reader-1.2
	)"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile spec/spec_helper.rb || die

	# Remove test that needs unpackaged dependency
	rm -f spec/manual_spec.rb || die
}
