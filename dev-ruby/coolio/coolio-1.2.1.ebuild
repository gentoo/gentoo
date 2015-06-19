# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/coolio/coolio-1.2.1.ebuild,v 1.3 2014/10/11 00:39:27 mrueg Exp $

EAPI=5

# iobuffer: -jruby -rbx
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_NAME="cool.io"

RUBY_FAKEGEM_GEMSPEC="cool.io.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="A high performance event framework for Ruby which uses the libev C library"
HOMEPAGE="http://coolio.github.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libev"
RDEPEND="${DEPEND}"

RUBY_PATCHES=( "${PN}-1.1.0-libev.patch" "${PN}-1.1.0-rubyio.patch" )

ruby_add_rdepend ">=dev-ruby/iobuffer-1"

all_ruby_prepare() {
	rm -r Gemfile* ext/libev ext/cool.io/libev.c lib/.gitignore || die

	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '28i  s.add_dependency "iobuffer"' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove specs that require network connectivity
	rm spec/dns_spec.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/cool.io extconf.rb || die
	${RUBY} -Cext/http11_client extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/cool.io
	cp ext/cool.io/cool.io_ext$(get_modname) lib/ || die

	emake V=1 -Cext/http11_client
	cp ext/http11_client/http11_client$(get_modname) lib/ || die
}
