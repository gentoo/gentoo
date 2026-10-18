# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="HISTORY README README.euc"

RUBY_FAKEGEM_EXTENSIONS=(./extconf.rb)

inherit flag-o-matic ruby-fakegem

DESCRIPTION="ruby shadow bindings"
HOMEPAGE="https://github.com/apalmblad/ruby-shadow"

LICENSE="|| ( public-domain Unlicense )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ~ppc64 ~riscv ~sparc x86"

PATCHES=(
	"${FILESDIR}/${P}-ruby32.patch"
	"${FILESDIR}/${P}-ruby32-taint.patch"
)

all_ruby_prepare() {
	sed -e '16i$CFLAGS += ENV["CFLAGS"]' \
		-i extconf.rb || die
}

src_configure() {
	# Definition no longer set in >=ruby40?
	append-cflags -DRUBY19 # doesn't respect CPPFLAGS

	ruby-ng_src_configure
}
