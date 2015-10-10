# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

inherit multilib ruby-fakegem

DESCRIPTION="Native Ruby bindings to itex2MML, which converts itex equations to MathML"
HOMEPAGE="http://golem.ph.utexas.edu/~distler/blog/itex2MML.html"

LICENSE="|| ( GPL-2+ MPL-1.1 LGPL-2+ )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

#Tests don't fail here
RESTRICT="test"

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext
	cp ext/itex2MML$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} test/test_itextomml.rb || die
}
