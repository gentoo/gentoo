# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/patron/patron-0.4.18-r2.ebuild,v 1.4 2015/02/19 07:19:01 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="README.txt"

inherit multilib ruby-fakegem

DESCRIPTION="Patron is a Ruby HTTP client library based on libcurl"
HOMEPAGE="http://toland.github.com/patron/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

#ruby_add_bdepend "test? ( dev-ruby/rspec:2 )"

DEPEND+=" net-misc/curl"
RDEPEND+=" net-misc/curl"

# Tests require a live web service that is not included in the distribution.
RESTRICT="test"

all_ruby_prepare() {
	# Fix rake deprecation
	sed -i -e 's:rake/rdoctask:rdoc/task:' Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext/patron extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/patron V=1
	cp ext/patron/session_ext$(get_modname) lib/patron/ || die "Unable to cp shared object file"
}
