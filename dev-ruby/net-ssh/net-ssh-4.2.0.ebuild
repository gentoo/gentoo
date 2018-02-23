# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc THANKS.txt"
RUBY_FAKEGEM_EXTRAINSTALL="support"

inherit ruby-fakegem

DESCRIPTION="Non-interactive SSH processing in pure Ruby"
HOMEPAGE="https://github.com/net-ssh/net-ssh"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> net-ssh-git-${PV}.tgz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="sodium test"

ruby_add_rdepend "virtual/ruby-ssl sodium? ( dev-ruby/rbnacl:4 dev-ruby/bcrypt_pbkdf )"
ruby_add_bdepend "test? ( dev-ruby/test-unit:2 >=dev-ruby/mocha-0.13 )"

all_ruby_prepare() {
	# Don't use a ruby-bundled version of libsodium
	sed -i -e '/rbnacl\/libsodium/ s:^:#:' lib/net/ssh/authentication/ed25519.rb || die

	# Avoid bundler dependency
	sed -i -e '/\(bundler\|:release\)/ s:^:#:' Rakefile || die
}
