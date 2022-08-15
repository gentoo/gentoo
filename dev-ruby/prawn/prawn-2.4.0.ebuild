# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRAINSTALL="data"

RUBY_FAKEGEM_GEMSPEC="prawn.gemspec"

inherit ruby-fakegem

DESCRIPTION="Fast, Nimble PDF Generation For Ruby"
HOMEPAGE="https://prawnpdf.org/"
SRC_URI="https://github.com/prawnpdf/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( GPL-2 GPL-3 Ruby )"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_rdepend "=dev-ruby/pdf-core-0.9*
	>=dev-ruby/ttfunk-1.7:*"
ruby_add_bdepend "test? ( dev-ruby/coderay
	>=dev-ruby/pdf-inspector-1.2.1
	>=dev-ruby/pdf-reader-1.4
	)"

all_ruby_prepare() {
	sed -i -e 's/__dir__/"."/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e "/[Bb]undler/d" Rakefile spec/spec_helper.rb || die

	# Remove test that needs unpackaged dependency
	rm -f spec/prawn_manual_spec.rb || die
}
