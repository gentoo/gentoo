# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc THANKS.txt"
RUBY_FAKEGEM_EXTRAINSTALL="support"

inherit ruby-fakegem

DESCRIPTION="Non-interactive SSH processing in pure Ruby"
HOMEPAGE="https://github.com/net-ssh/net-ssh"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> net-ssh-git-${PV}.tgz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="ed25519 test"

ruby_add_rdepend "virtual/ruby-ssl ed25519? ( dev-ruby/ed25519 dev-ruby/bcrypt_pbkdf )"
ruby_add_bdepend "test? ( dev-ruby/test-unit:2 >=dev-ruby/mocha-0.13 )"

all_ruby_prepare() {
	# Avoid bundler dependency
	sed -i -e '/\(bundler\|:release\)/ s:^:#:' Rakefile || die
}

src_test() {
	# prevent tests from trying to connect to ssh-agent socket and failing
	unset SSH_AUTH_SOCK
	if ! use ed25519; then
		export NET_SSH_NO_ED25519=true
	fi
	ruby-ng_src_test
}
