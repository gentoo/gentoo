# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_GEMSPEC="selenium-webdriver.gemspec"

inherit ruby-fakegem

DESCRIPTION="This gem provides Ruby bindings for WebDriver"
HOMEPAGE="https://github.com/seleniumhq/selenium"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND=">=dev-util/selenium-manager-$(ver_cut 1-2)"

ruby_add_rdepend "
	|| ( dev-ruby/base64:0.3 dev-ruby/base64:0.2 )
	>=dev-ruby/logger-1.4:0
	>=dev-ruby/rexml-3.2.5:3
	|| ( dev-ruby/rubyzip:3 dev-ruby/rubyzip:2 )
	dev-ruby/websocket:0
"

all_ruby_prepare() {
	# Remove the pre-compiled selenium-manager executables
	rm -fr bin || die
}

pkg_postinst() {
	ewarn "This package now uses the SE_MANAGER_PATH environment "
	ewarn "variable to locate selenium-manager.  This variable is"
	ewarn "provided by the selenium-manager package but may not be"
	ewarn "available yet directly after the update."
}
