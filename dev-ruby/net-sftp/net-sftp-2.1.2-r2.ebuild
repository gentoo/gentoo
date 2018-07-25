# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="SFTP in pure Ruby"
HOMEPAGE="https://github.com/net-ssh/net-sftp"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_PATCHES=( "${FILESDIR}/${P}-net-ssh-4.patch" )

ruby_add_rdepend "|| ( dev-ruby/net-ssh:4 dev-ruby/net-ssh:2.6 )"

ruby_add_bdepend "
	test? (
		>=dev-ruby/mocha-0.13
	)"
