# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="README.txt"

inherit multilib ruby-fakegem

DESCRIPTION="Patron is a Ruby HTTP client library based on libcurl"
HOMEPAGE="https://toland.github.com/patron/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

#ruby_add_bdepend "test? ( dev-ruby/rspec:2 )"

DEPEND+=" net-misc/curl"
RDEPEND+=" net-misc/curl"

# Tests require a live web service that is not included in the distribution.
RESTRICT="test"

each_ruby_configure() {
	${RUBY} -Cext/patron extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/patron V=1
	cp ext/patron/session_ext$(get_modname) lib/patron/ || die "Unable to cp shared object file"
}
