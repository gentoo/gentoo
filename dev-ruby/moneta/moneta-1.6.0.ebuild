# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="none"
# test is disabled for now. It requires many packages.  Test suite also
# takes very long run time and has high memory consumption.

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md SPEC.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A unified interface to key/value stores"
HOMEPAGE="https://github.com/moneta-rb/moneta"
SRC_URI="https://github.com/moneta-rb/moneta/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

all_ruby_prepare() {
	sed -e "s/__dir__/'.'/" \
		-e "s/_relative//" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
