# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Provides a high-level toolkit for building cryptographic systems and protocols"
HOMEPAGE="https://github.com/cryptosphere/rbnacl"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND+=" dev-libs/libsodium"
DEPEND+=" test? ( dev-libs/libsodium )"

ruby_add_rdepend "dev-ruby/ffi"

PATCHES=( "${FILESDIR}/rbnacl-buffer-size.patch" )

all_ruby_prepare() {
	sed -i -e '/coveralls/I s:^:#:' \
		-e '/bundler/ s:^:#:' \
		-e 's:rbnacl/libsodium:rbnacl:' spec/spec_helper.rb
}
