# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/mri/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Implements bcrypt_pdkfd (a variant of PBKDF2 with bcrypt-based PRF)"
HOMEPAGE="https://github.com/net-ssh/bcrypt_pbkdf-ruby"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""

ruby_add_bdepend "test? ( virtual/ruby-ssl )"

all_ruby_prepare() {
	# Don't use a ruby-bundled version of libsodium
	sed -i -e '/rbnacl\/libsodium/ s:^:#:' test/bcrypt_pnkdf/engine_test.rb || die

	# Avoid unneeded rake-compiler dependency
	sed -e '/extensiontask/ s:^:#:' -e '/ExtensionTask/,/^end/ s:^:#:' \
		-e '/bundler/ s:^:#:' \
		-i Rakefile || die

	sed -i -e 's/git ls-files/find * -print/' bcrypt_pbkdf.gemspec || die
}

each_ruby_configure() {
	each_fakegem_configure
	# Some methods may not be inlined on x86 but they are not defined either, bug 629164

	sed -i -e 's:-Wl,--no-undefined::' ext/mri/Makefile || die
}
