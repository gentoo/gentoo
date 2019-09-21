# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="A pure Ruby implementation of the SCP client protocol"
HOMEPAGE="https://github.com/net-ssh/net-scp"
SRC_URI="https://github.com/net-ssh/net-scp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_PATCHES=(
	${P}-raise-correct-errors.patch
	${P}-fix-common.path
	${P}-fix-download_test.patch
	${P}-fix-download_test_2.patch
	${P}-fix-download_test_3.patch
	${P}-fix-upload_tests.patch
	${P}-raise-correct-errors-net-ssh-4.0-compat.patch
	)

ruby_add_bdepend "
	doc? ( || ( dev-ruby/net-ssh:5 dev-ruby/net-ssh:4 ) )
	test? (
		|| ( dev-ruby/net-ssh:5 dev-ruby/net-ssh:4 )
		dev-ruby/mocha
	)"

ruby_add_rdepend "|| ( dev-ruby/net-ssh:5 dev-ruby/net-ssh:4 )"

each_ruby_test() {
	${RUBY} -Ilib:test test/test_all.rb || die
}
