# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="ttfunk.gemspec"

inherit ruby-fakegem

DESCRIPTION="A TrueType font parser written in pure ruby"
HOMEPAGE="https://github.com/prawnpdf/ttfunk/"
SRC_URI="https://github.com/prawnpdf/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 Ruby )"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' spec/spec_helper.rb || die
}
