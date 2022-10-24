# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"
RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="A fast and scalable test runner"
HOMEPAGE="https://github.com/ioquatix/sus"
SRC_URI="https://github.com/ioquatix/sus/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die
	sed -i -E '/^#/!d' "config/${PN}.rb" || die # remove covered coverage
}

each_ruby_test() {
	"${RUBY}" "bin/sus-parallel" || die
}
