# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby poppler-glib bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" app-text/poppler[cairo]"
DEPEND+=" app-text/poppler[cairo]"

ruby_add_rdepend "
	~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-gio2-${PV}
"

all_ruby_prepare() {
	# Avoid compilation of dependencies during test.
	sed -i -e '/if have_make/,/^    end/ s:^:#:' test/run-test.rb || die

	# Avoid tests downloading a test PDF directly.
	rm -f test/test_{annotation,document,page}.rb || die
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
