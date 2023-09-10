# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Cross-platform interface for filesystem information"
HOMEPAGE="https://github.com/djberg96/sys-filesystem"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ffi-1.15.0"

#ruby_add_bdepend "test? ( dev-ruby/mkmf-lite )"

all_ruby_prepare() {
	:
	#sed -e 's/__dir__/"."/' \
	#	-e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
	#	-i "${RUBY_FAKEGEM_GEMSPEC}" || die
}
