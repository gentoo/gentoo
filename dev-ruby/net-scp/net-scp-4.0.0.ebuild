# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_GEMSPEC="net-scp.gemspec"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby implementation of the SCP client protocol"
HOMEPAGE="https://github.com/net-ssh/net-scp"
SRC_URI="https://github.com/net-ssh/net-scp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

ruby_add_bdepend "
	doc? ( dev-ruby/net-ssh:7 )
	test? (
		dev-ruby/mocha:2
		dev-ruby/test-unit
	)"

ruby_add_rdepend "dev-ruby/net-ssh:7"

all_ruby_prepare() {
	sed -e "s:_relative ': './:" \
		-e 's/git ls-files -z/find -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -e '/mocha/ s/setup/test_unit/' \
		-i test/common.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/test_all.rb || die
}
