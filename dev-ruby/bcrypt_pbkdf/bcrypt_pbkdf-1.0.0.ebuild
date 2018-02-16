# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Implements bcrypt_pdkfd (a variant of PBKDF2 with bcrypt-based PRF)"
HOMEPAGE="https://github.com/net-ssh/bcrypt_pbkdf-ruby"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rbnacl )"

all_ruby_prepare() {
	# Don't use a ruby-bundled version of libsodium
	sed -i -e '/rbnacl\/libsodium/ s:^:#:' test/bcrypt_pnkdf/engine_test.rb || die

	# Avoid unneeded rake-compiler dependency
	sed -i -e '/extensiontask/ s:^:#:' -e '/ExtensionTask/,/^end/ s:^:#:' Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext/mri extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/mri
	cp ext/mri/bcrypt_pbkdf_ext.so lib/ || die
}
