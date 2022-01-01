# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26"

RUBY_FAKEGEM_GEMSPEC="duktape.gemspec"
RUBY_FAKEGEM_NAME="duktape"

inherit ruby-fakegem

MY_PN=${PN/-/\.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Ruby bindings to the Duktape JavaScript interpeter"
HOMEPAGE="https://github.com/judofyr/duktape.rb"
SRC_URI="https://github.com/judofyr/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Tests require dev-ruby/sdoc, which is currently ~arch-only and fairly limited
# in the number of supported keywords.
RESTRICT="test"

# Upstream uses bundled single-source distributable Duktape.
#RDEPEND+="dev-lang/duktape"

ruby_add_bdepend "dev-ruby/rake-compiler"

RUBY_S=${MY_P}

each_ruby_compile() {
	${RUBY} -S rake compile
}
