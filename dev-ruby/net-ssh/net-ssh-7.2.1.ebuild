# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.md THANKS.txt"
RUBY_FAKEGEM_EXTRAINSTALL="support"

RUBY_FAKEGEM_GEMSPEC="net-ssh.gemspec"

inherit ruby-fakegem

DESCRIPTION="Non-interactive SSH processing in pure Ruby"
HOMEPAGE="https://github.com/net-ssh/net-ssh"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> net-ssh-git-${PV}.tgz"

LICENSE="GPL-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="chacha20 ed25519 test"
RESTRICT="!test? ( test )"

ruby_add_rdepend "
	virtual/ruby-ssl
	chacha20? ( dev-ruby/rbnacl )
	ed25519? ( >=dev-ruby/ed25519-1.2:1 dev-ruby/x25519 dev-ruby/bcrypt_pbkdf:1 )
"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 >=dev-ruby/mocha-0.13 )"

all_ruby_prepare() {
	# Avoid bundler dependency
	sed -i -e '/\(bundler\|:release\)/ s:^:#:' Rakefile || die

	sed -e "s:require_relative ':require './:" \
		-e 's/git ls-files -z/find -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

src_test() {
	# prevent tests from trying to connect to ssh-agent socket and failing
	unset SSH_AUTH_SOCK
	if ! use ed25519; then
		export NET_SSH_NO_ED25519=true
	fi
	ruby-ng_src_test
}
