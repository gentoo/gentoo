# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.rdoc"

RUBY_FAKEGEM_GEMSPEC="net-sftp.gemspec"

inherit ruby-fakegem

DESCRIPTION="SFTP in pure Ruby"
HOMEPAGE="https://github.com/net-ssh/net-sftp"
SRC_URI="https://github.com/net-ssh/net-sftp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE=""

ruby_add_rdepend "|| ( dev-ruby/net-ssh:7 dev-ruby/net-ssh:6 )"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		>=dev-ruby/mocha-0.13
	)"

all_ruby_prepare() {
	sed -i -e "s:_relative ': './:" -e 's/git ls-files -z/find -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	MT_NO_PLUGINS=1 ${RUBY} -Ilib:test:. -e 'Dir["test/**/test_*.rb"].each { require _1 }' || die
}
