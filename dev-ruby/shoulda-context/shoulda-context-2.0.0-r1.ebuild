# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"

RUBY_FAKEGEM_EXTRAINSTALL="tasks"

# Don't install the conversion script to avoid collisions with older
# shoulda.
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Context framework extracted from Shoulda"
HOMEPAGE="https://github.com/thoughtbot/shoulda-context"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="doc test"

PATCHES=( "${FILESDIR}/${P}-file-exists.patch" )

ruby_add_bdepend "test? ( dev-ruby/minitest:5
	>=dev-ruby/mocha-1.0 )"

all_ruby_prepare() {
	sed -e '/\(current_bundle\|CurrentBundle\)/ s:^:#:' \
		-e '/pry-byebug/ s:^:#:' \
		-e '/warnings_logger/ s:^:#: ; /WarningsLogger/,/^)/ s:^:#:' \
		-e '/rails_application_with_shoulda_context/ s:^:#:' \
		-e '2igem "minitest", "~> 5.0"' \
		-i test/test_helper.rb || die
	rm -f test/shoulda/{railtie,rerun_snippet,test_framework_detection}_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/shoulda/*_test.rb"].each { require _1 }' || die
}
