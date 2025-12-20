# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="rails init.rb VERSION VERSION_NAME"

inherit ruby-fakegem

DESCRIPTION="An extension of CSS3, adding nested rules, variables, mixins, and more"
HOMEPAGE="https://sass-lang.com/"
SRC_URI="https://github.com/sass/ruby-sass/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-sass-${PV}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc ~x86"
IUSE="doc test"

ruby_add_bdepend "
	doc? ( >=dev-ruby/yard-0.5.3 )
	test? ( dev-ruby/minitest )
"

ruby_add_rdepend "
	!!<dev-ruby/sass-3.4.25-r1:3.4
	!!<dev-ruby/sass-3.5.7-r1:3.5
	dev-ruby/listen
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.7.4-use-listen-not-sass-listen.patch
)

# tests could use `less` if we had it

all_ruby_prepare() {
	# We use dev-ruby/listen now instead of dev-ruby/sass-listen
	sed -i \
		-e "/sass-listen/s:, '~> 4.0.0'::" \
		-e "s:sass-listen:listen:" \
		${PN}.gemspec || die

	# Don't require maruku as markdown provider but let yard decide.
	sed -i -e '/maruku/d' .yardopts || die

	# Keep VERSION_DATE around since we don't create a new package
	sed -i -e '/at_exit/,/end/ s:^:#:' Rakefile || die

	# Fix minitest deprecations
	sed -e 's/MiniTest/Minitest/' \
		-i test/test_helper.rb test/sass/test_helper.rb test/sass/*_test.rb test/sass/{scss,util}/*_test.rb || die
}

each_ruby_test() {
	RUBOCOP=false ${RUBY} -S rake test:ruby || die
}
