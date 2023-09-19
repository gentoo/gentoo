# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="readme.md security.md"

RUBY_FAKEGEM_GEMSPEC="rackup.gemspec"

inherit ruby-fakegem

DESCRIPTION="A general server command for Rack applications"
HOMEPAGE="https://github.com/rack/rackup"
SRC_URI="https://github.com/rack/rackup/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/rack:3.0
	>=dev-ruby/webrick-1.8:0
	virtual/ruby-ssl
	!<dev-ruby/rack-2.2.7-r1
"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/minitest-global_expectations
)"

all_ruby_prepare() {
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib:test:. -e "Dir['test/spec_*.rb'].each{ require _1 }" || die
}
