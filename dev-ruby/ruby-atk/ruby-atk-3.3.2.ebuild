# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Atk bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""
DEPEND+=" dev-libs/atk"
RDEPEND+=" dev-libs/atk"

ruby_add_rdepend "~dev-ruby/ruby-glib2-${PV}"

all_ruby_prepare() {
	# Avoid unneeded dependency on test-unit-notify.
	sed -i -e '/notify/ s:^:#:' test/atk-test-utils.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_install() {
	each_fakegem_install
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
