# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="rails init.rb VERSION VERSION_NAME"

inherit ruby-fakegem eapi7-ver

DESCRIPTION="An extension of CSS3, adding nested rules, variables, mixins, and more"
HOMEPAGE="https://sass-lang.com/"
SRC_URI="https://github.com/sass/ruby-sass/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-sass-${PV}"

LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux"
SLOT="$(ver_cut 1-2)"
IUSE=""

ruby_add_bdepend "doc? ( >=dev-ruby/yard-0.5.3 )"

ruby_add_rdepend "
	!!<dev-ruby/sass-3.2.19-r1:0
	!!<dev-ruby/sass-3.4.25-r1:3.4
	!!<dev-ruby/sass-3.5.7-r1:3.5
	dev-ruby/sass-listen:4"

# tests could use `less` if we had it

all_ruby_prepare() {
	# Don't require maruku as markdown provider but let yard decide.
	sed -i -e '/maruku/d' .yardopts || die

	# Keep VERSION_DATE around since we don't create a new package
	sed -i -e '/at_exit/,/end/ s:^:#:' Rakefile || die
}

each_ruby_test() {
	RUBOCOP=false ${RUBY} -S rake test:ruby || die
}
