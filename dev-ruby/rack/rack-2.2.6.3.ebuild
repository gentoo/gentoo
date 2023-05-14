# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc SPEC.rdoc"

RUBY_FAKEGEM_GEMSPEC="rack.gemspec"

inherit ruby-fakegem

DESCRIPTION="A modular Ruby webserver interface"
HOMEPAGE="https://github.com/rack/rack"
SRC_URI="https://github.com/rack/rack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE=""

ruby_add_rdepend "virtual/ruby-ssl"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/minitest-global_expectations
	dev-ruby/concurrent-ruby
	=dev-ruby/psych-4*
	dev-ruby/webrick
)"

# The gem has automagic dependencies over mongrel, ruby-openid,
# memcache-client, thin, mongrel and camping; not sure if we should
# make them dependencies at all.

# Block against versions in older slots that also try to install a binary.
RDEPEND="${RDEPEND} !!<dev-ruby/rack-2.1.1-r1:2.1"

all_ruby_prepare() {
	# The build system tries to generate the ChangeLog from git. Create
	# an empty file to avoid a needless dependency on git.
	touch ChangeLog || die

	# Avoid development dependency
	sed -i -e '/minitest-sprint/ s:^:#:' -e "s:require_relative ':require './:" rack.gemspec || die

	# Avoid test failing due to security version number usage
	sed -i -e '/support -v option to get version/askip "broken with security version number"' test/spec_server.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e "require 'test/gemloader.rb'; Dir['test/spec_*.rb'].each{|f| require f}" || die
}
