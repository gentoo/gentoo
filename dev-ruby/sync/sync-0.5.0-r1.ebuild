# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A module that provides a two-phase lock with a counter"
HOMEPAGE="https://github.com/ruby/sync"
SRC_URI="https://github.com/ruby/sync/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ruby/sync/commit/8f2821d0819ee7c08506f204c7676f12c5ab1397.patch -> ${P}-mjit.patch"

LICENSE="BSD-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~sparc x86"

all_ruby_prepare() {
	eapply "${DISTDIR}/${P}-mjit.patch"

	sed -i -e 's:require_relative ":require "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
