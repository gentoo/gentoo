# Copyright 2000-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_BINWRAP="thor"

RUBY_FAKEGEM_GEMSPEC="thor.gemspec"

inherit ruby-fakegem

DESCRIPTION="Simple and efficient tool for building self-documenting command line utilities"
HOMEPAGE="http://whatisthor.com/"
SRC_URI="https://github.com/erikhuda/${PN}/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux"
IUSE="doc"

# For initial target porting (new rubies), we can make these test deps
# conditional with:
# 1. USE_RUBY="<old rubies>" ruby_add_bdepend ...
# 2. skip logic in each_ruby_test
USE_RUBY="ruby30 ruby31 ruby32" ruby_add_bdepend "
	test? (
		dev-ruby/childlabor
		dev-ruby/webmock
	)"

RDEPEND+=" !<dev-ruby/thor-0.20.3-r1:0"

PATCHES=(
	"${FILESDIR}"/thor-1.2.2-no-coverage.patch
)

all_ruby_prepare() {
	# Remove rspec default options (as we might not have the last
	# rspec).
	rm .rspec || die

	# Remove Bundler
	#rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Thorfile || die

	# Remove mandatory coverage collection using simplecov which is not
	# packaged.
	#sed -i -e '/require "simplecov"/,/^end/ s:^:#:' spec/helper.rb || die

	# Avoid a spec that requires UTF-8 support, so LANG=C still works,
	# bug 430402
	#sed -i -e '/uses maximum terminal width/,/end/ s:^:#:' spec/shell/basic_spec.rb || die

	# Avoid specs depending on git, bug 724058
	rm -f spec/quality_spec.rb || die

	# Avoid currently broken readline specs (already fixed upstream)
	rm -f spec/line_editor/readline_spec.rb spec/line_editor_spec.rb || die

	# Avoid spec failing on whitespace difference in error message
	sed -i -e '/raises an error for unknown switches/askip "whitespace differences"' spec/parser/options_spec.rb || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby33)
			einfo "Skipping tests due to circular dependencies"
			;;
		*)
			RSPEC_VERSION=3 ruby-ng_rspec spec || die
			;;
	esac
}
