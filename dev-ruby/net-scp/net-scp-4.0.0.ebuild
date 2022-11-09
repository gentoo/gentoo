# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_GEMSPEC="net-scp.gemspec"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby implementation of the SCP client protocol"
HOMEPAGE="https://github.com/net-ssh/net-scp"
SRC_URI="https://github.com/net-ssh/net-scp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

ruby_add_bdepend "
	doc? ( || ( dev-ruby/net-ssh:7 dev-ruby/net-ssh:6 dev-ruby/net-ssh:5 ) )
	test? (
		dev-ruby/mocha
	)"

ruby_add_rdepend "|| ( dev-ruby/net-ssh:7 dev-ruby/net-ssh:6 dev-ruby/net-ssh:5 )"

all_ruby_prepare() {
	sed -e "s:_relative ': './:" \
		-e 's/git ls-files -z/find -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/test_all.rb || die
}
