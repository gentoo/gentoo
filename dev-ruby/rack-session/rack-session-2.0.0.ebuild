# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="rack-session.gemspec"

inherit ruby-fakegem

DESCRIPTION="A session implementation for Rack"
HOMEPAGE="https://github.com/rack/rack-session"
SRC_URI="https://github.com/rack/rack-session/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-3.0.0"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/minitest-global_expectations
)"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
