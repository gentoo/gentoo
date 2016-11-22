# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# iobuffer: -rbx
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_NAME="cool.io"

RUBY_FAKEGEM_GEMSPEC="cool.io.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="A high performance event framework for Ruby which uses the libev C library"
HOMEPAGE="https://coolio.github.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND+=" >=dev-libs/libev-4.20"
RDEPEND+=" >=dev-libs/libev-4.20"

RUBY_PATCHES=( "${PN}-1.1.0-libev.patch" )

ruby_add_rdepend ">=dev-ruby/iobuffer-1"

all_ruby_prepare() {
	rm -r Gemfile* ext/libev ext/cool.io/libev.c lib/.gitignore || die

	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '28i  s.add_dependency "iobuffer"' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid dependency on rake-compiler
	sed -i -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^end/ s:^:#:' Rakefile || die

	# Remove specs that require network connectivity
	rm -f spec/dns_spec.rb || die

	# Use one address consistently
	sed -i -e 's/localhost/127.0.0.1/' spec/{udp_socket,tcp_server,iobuffer}_spec.rb || die

	# Remove specs that fail, possibly due to libev
	# incompatibility. Should be investigated but cool.io is no longer
	# maintained.
	rm -f spec/udp_socket_spec.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/cool.io extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/cool.io
	cp ext/cool.io/cool.io_ext$(get_modname) lib/ || die
}
