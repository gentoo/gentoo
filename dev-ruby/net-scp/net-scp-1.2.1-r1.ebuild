# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="A pure Ruby implementation of the SCP client protocol"
HOMEPAGE="https://github.com/net-ssh/net-scp"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

RUBY_PATCHES=( ${P}-fix-download_tests.patch  ${P}-fix-upload_tests.patch )


ruby_add_bdepend "
	doc? ( >=dev-ruby/net-ssh-4.0:4 )
	test? (
		>=dev-ruby/net-ssh-4.0:4
		dev-ruby/mocha
	)"

ruby_add_rdepend ">=dev-ruby/net-ssh-4.0:4"

all_ruby_prepare() {
	sed -i -e 's/>= 2.0.0/~> 2.0/' test/common.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/test_all.rb || die
}
