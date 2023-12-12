# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="HISTORY README README.euc"

RUBY_FAKEGEM_EXTENSIONS=(./extconf.rb)

inherit ruby-fakegem

DESCRIPTION="ruby shadow bindings"
HOMEPAGE="https://github.com/apalmblad/ruby-shadow"

LICENSE="|| ( public-domain Unlicense )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ~ppc64 ~riscv ~sparc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-ruby32.patch"
	"${FILESDIR}/${P}-ruby32-taint.patch"
)

all_ruby_prepare() {
	sed -e '16i$CFLAGS += ENV["CFLAGS"]' \
		-i extconf.rb || die
}
