# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_NAME="cool.io"

RUBY_FAKEGEM_GEMSPEC="cool.io.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="A high performance event framework for Ruby which uses the libev C library"
HOMEPAGE="https://coolio.github.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# cool.io includes a bundled version of libev that is patched to work correctly with ruby.

ruby_add_rdepend ">=dev-ruby/iobuffer-1"

all_ruby_prepare() {
	rm -r Gemfile* lib/.gitignore || die

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
}

each_ruby_configure() {
	pushd ext/cool.io || die
	${RUBY} extconf.rb || die
	popd || die
}

each_ruby_compile() {
	pushd ext/cool.io || die
	emake V=1
	popd || die
	cp ext/cool.io/cool.io_ext$(get_modname) lib/ || die
}
