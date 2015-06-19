# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/atomic/atomic-1.1.99.ebuild,v 1.1 2015/01/27 06:42:12 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""

inherit multilib ruby-fakegem

DESCRIPTION="An atomic reference implementation for JRuby, Rubinius, and MRI"
HOMEPAGE="https://github.com/headius/ruby-atomic"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

all_ruby_prepare() {
	# Avoid compilation dependencies since we compile directly.
	sed -i -e '/:test => :compile/ s:^:#:' \
		-e '/extensiontask/,/end/ s:^:#:' Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext
	cp ext/atomic_reference$(get_modname) lib/ || die
}
