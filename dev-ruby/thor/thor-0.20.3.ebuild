# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_BINWRAP="thor"

inherit ruby-fakegem

DESCRIPTION="A scripting framework that replaces rake and sake"
HOMEPAGE="http://whatisthor.com/"

SRC_URI="https://github.com/erikhuda/${PN}/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="doc"

USE_RUBY="ruby23 ruby24 ruby25" ruby_add_bdepend "
	test? (
		dev-ruby/childlabor
		dev-ruby/webmock
	)"

all_ruby_prepare() {
	# Remove rspec default options (as we might not have the last
	# rspec).
	rm .rspec || die

	# Remove Bundler
	#rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Thorfile || die

	# Remove mandatory coverage collection using simplecov which is not
	# packaged.
	sed -i -e '/require .simplecov/,/^  end/ s:^:#:' spec/helper.rb || die

	# Avoid a spec that requires UTF-8 support, so LANG=C still works,
	# bug 430402
	sed -i -e '/uses maximum terminal width/,/end/ s:^:#:' spec/shell/basic_spec.rb || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby27)
			einfo "Skipping tests due to circular dependencies"
			;;
		*)
			RSPEC_VERSION=3 ruby-ng_rspec spec || die
			;;
	esac
}
