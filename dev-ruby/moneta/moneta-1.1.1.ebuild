# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="none"
# test is disabled for now. It requires many packages.  Test suite also
# takes very long run time and has high memory consumption.

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md SPEC.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

GITHUB_USER="minad"

DESCRIPTION="A unified interface to key/value stores"
HOMEPAGE="https://github.com/minad/moneta"
SRC_URI="https://github.com/${GITHUB_USER}/moneta/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}
