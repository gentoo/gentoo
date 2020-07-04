# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.rdoc README.signals"

inherit multilib ruby-fakegem

DESCRIPTION="FastCGI library for Ruby"
HOMEPAGE="https://github.com/alphallc/ruby-fcgi-ng"

KEYWORDS="amd64 arm hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
LICENSE="Ruby"

DEPEND+=" dev-libs/fcgi"
RDEPEND+=" dev-libs/fcgi"

IUSE=""
SLOT="0"

each_ruby_configure() {
	${RUBY} -C ext/fcgi extconf.rb || die "extconf failed"
}

each_ruby_compile() {
	emake V=1 -C ext/fcgi
	cp ext/fcgi/fcgi$(get_modname) lib || die
}
