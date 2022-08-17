# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.org History.org"
RUBY_FAKEGEM_GEMSPEC="org-ruby.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby routines for parsing org-mode files"
HOMEPAGE="https://github.com/wallyqs/org-ruby"
SRC_URI="https://github.com/wallyqs/${PN}/archive/version-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RUBY_S="${PN}-version-${PV}"

ruby_add_rdepend ">=dev-ruby/rubypants-0.2:0"
ruby_add_bdepend "test? ( dev-ruby/tilt )"

all_ruby_prepare() {
	sed -i -e '1irequire "pathname"' spec/spec_helper.rb || die
}
