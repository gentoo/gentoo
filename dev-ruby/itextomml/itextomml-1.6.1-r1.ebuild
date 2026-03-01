# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README"
RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem flag-o-matic

DESCRIPTION="Native Ruby bindings to itex2MML, which converts itex equations to MathML"
HOMEPAGE="https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"

LICENSE="|| ( GPL-2+ MPL-1.1 LGPL-2+ )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"

#Tests don't fail here
RESTRICT="test"

all_ruby_prepare() {
	append-cflags -std=gnu17 #944196

	default
}

each_ruby_test() {
	${RUBY} test/test_itextomml.rb || die
}
