# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_GEMSPEC="certificate_authority.gemspec"

inherit ruby-fakegem

DESCRIPTION="Managing the core functions outlined in RFC-3280 for PKI"
HOMEPAGE="https://github.com/cchandler/certificate_authority"
SRC_URI="https://github.com/cchandler/certificate_authority/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/\(bundler\|pry\|overalls\)/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/spec.files/,/end/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid dependency on dev-libs/engine_pkcs11 that will be hard to
	# make work on different arches due to hardwired load paths in
	# specs.
	rm -f spec/units/pkcs11_key_material_spec.rb || die
}
