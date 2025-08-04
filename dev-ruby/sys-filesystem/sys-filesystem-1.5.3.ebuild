# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Cross-platform interface for filesystem information"
HOMEPAGE="https://github.com/djberg96/sys-filesystem"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

ruby_add_depend "test? ( dev-ruby/mkmf-lite )"

ruby_add_rdepend ">=dev-ruby/ffi-1.15.0"

all_ruby_prepare() {
	sed -e '/stat fragment_size is a plausible value/askip "Fails with e.g. ZFS"' \
		-i spec/sys_filesystem_unix_spec.rb || die
}
