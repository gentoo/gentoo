# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem versionator

DESCRIPTION="A TrueType font parser written in pure ruby"
HOMEPAGE="https://github.com/prawnpdf/ttfunk/"
SRC_URI="https://github.com/prawnpdf/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 Ruby )"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' spec/spec_helper.rb || die
}
