# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="ox.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/ox/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/ox

inherit ruby-fakegem

DESCRIPTION="A fast XML parser and Object marshaller"
HOMEPAGE="https://www.ohler.com/ox/ https://github.com/ohler55/ox"
SRC_URI="https://github.com/ohler55/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"

ruby_add_rdepend ">=dev-ruby/bigdecimal-3.0"

each_ruby_test() {
	${RUBY} test/tests.rb || die
}
