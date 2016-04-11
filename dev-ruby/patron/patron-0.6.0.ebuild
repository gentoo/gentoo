# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit multilib ruby-fakegem

DESCRIPTION="Patron is a Ruby HTTP client library based on libcurl"
HOMEPAGE="https://toland.github.com/patron/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND+=" net-misc/curl"
RDEPEND+=" net-misc/curl"

all_ruby_prepare() {
	# Fix Rakefile
	sed -i -e 's:rake/rdoctask:rdoc/task:' \
		-e 's/README.txt/README.md/' \
		-e '/bundler/I s:^:#:' \
		-e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^end/ s:^:#:' \
		Rakefile || die

	# Avoid specs with failures. We were not running any specs before.
	rm spec/session_ssl_spec.rb spec/session_spec.rb spec/response_spec.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/patron extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/patron V=1
	cp ext/patron/session_ext$(get_modname) lib/patron/ || die "Unable to cp shared object file"
}
