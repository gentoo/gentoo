# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

COMMIT=7a28c2e6e91cdaceb1fddc2d870f4458632816e8

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.org History.org"
RUBY_FAKEGEM_GEMSPEC="org-ruby.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby routines for parsing org-mode files"
HOMEPAGE="https://github.com/wallyqs/org-ruby"
SRC_URI="https://github.com/wallyqs/org-ruby/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

PATCHES=( "${FILESDIR}/org-ruby-0.9.12-file-exists.patch" )

ruby_add_rdepend ">=dev-ruby/rubypants-0.2:0"
ruby_add_bdepend "test? ( dev-ruby/tilt )"

all_ruby_prepare() {
	sed -i -e '1irequire "pathname"' spec/spec_helper.rb || die
}
