# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="readme.md"

RUBY_FAKEGEM_GEMSPEC="timers.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="sus"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby one-shot and periodic timers"
HOMEPAGE="https://github.com/socketry/timers"
SRC_URI="https://github.com/socketry/timers/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86 ~ppc-macos ~x64-macos ~x64-solaris"

PATCHES=(
	# https://github.com/socketry/timers/issues/82
	"${FILESDIR}"/${P}-timers-slow.patch
)

all_ruby_prepare() {
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid performance-based tests since we cannot guarantee specific performance levels.
	rm -f test/timers/performance.rb || die
}
