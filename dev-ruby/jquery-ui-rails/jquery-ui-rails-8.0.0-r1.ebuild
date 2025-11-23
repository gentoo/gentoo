# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="History.md README.md VERSIONS.md"

RUBY_FAKEGEM_EXTRAINSTALL="app"
RUBY_FAKEGEM_GEMSPEC="jquery-ui-rails.gemspec"

inherit ruby-fakegem

DESCRIPTION="The jQuery UI assets for the Rails 3.2+ asset pipeline"
HOMEPAGE="https://github.com/jquery-ui-rails/jquery-ui-rails"
SRC_URI="https://github.com/jquery-ui-rails/jquery-ui-rails/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"

PATCHES=( "${FILESDIR}/${P}-version.patch" )

ruby_add_rdepend ">=dev-ruby/railties-3.2.16:*"

all_ruby_prepare() {
	sed -e '/executables/ s:^:#:' \
		-e 's/git ls-files/find */' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
