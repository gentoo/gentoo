# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="sus"
RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="fiber-storage.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provides a compatibility shim for fiber storage"
HOMEPAGE="https://github.com/ioquatix/fiber-storage"
SRC_URI="https://github.com/ioquatix/fiber-storage/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~sparc"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	rm -f config/sus.rb || die
}
