# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md SECURITY.md SPEC.rdoc UPGRADE-GUIDE.md"

RUBY_FAKEGEM_GEMSPEC="rack.gemspec"

inherit ruby-fakegem

DESCRIPTION="A modular Ruby webserver interface"
HOMEPAGE="https://github.com/rack/rack"
SRC_URI="https://github.com/rack/rack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"

ruby_add_rdepend "virtual/ruby-ssl"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/minitest-global_expectations
	dev-ruby/webrick
)"

# The gem has automagic dependencies over mongrel, ruby-openid,
# memcache-client, thin, mongrel and camping; not sure if we should
# make them dependencies at all.

all_ruby_prepare() {
	# The build system tries to generate the ChangeLog from git. Create
	# an empty file to avoid a needless dependency on git.
	touch ChangeLog || die

	sed -i -e "s:require_relative ':require './:" rack.gemspec || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e "require 'test/gemloader.rb'; Dir['test/spec_*.rb'].each{|f| require f}" || die
}
