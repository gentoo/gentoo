# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"
RUBY_FAKEGEM_EXTRADOC="README"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Native Ruby bindings to itex2MML, which converts itex equations to MathML"
HOMEPAGE="https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"

LICENSE="|| ( GPL-2+ MPL-1.1 LGPL-2+ )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

#Tests don't fail here
RESTRICT="test"

each_ruby_test() {
	${RUBY} test/test_itextomml.rb || die
}
