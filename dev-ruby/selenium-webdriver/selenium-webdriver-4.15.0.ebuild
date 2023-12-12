# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_GEMSPEC="selenium-webdriver.gemspec"

inherit ruby-fakegem

DESCRIPTION="This gem provides Ruby bindings for WebDriver"
HOMEPAGE="https://github.com/seleniumhq/selenium"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND+=" >=dev-util/selenium-manager-$(ver_cut 1-2)"

ruby_add_rdepend "
	>=dev-ruby/rexml-3.2.5:3
	>=dev-ruby/rubyzip-1.2.2:*
	dev-ruby/websocket:0
"

PATCHES=( "${FILESDIR}/${PN}-4.13.1-selenium-manager.patch" )

all_ruby_prepare() {
	# Remove the pre-compiled selenium-manager executables
	rm -fr bin || die
}
