# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md History"

inherit ruby-fakegem

DESCRIPTION="Really simple JSON and XML parsing, ripped from Merb and Rails"
HOMEPAGE="https://github.com/jnunemaker/crack"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"
ruby_add_rdepend ">=dev-ruby/safe_yaml-1.0.4-r4"

each_ruby_prepare() {
	# Remove tests which fail when run by portage but pass when run by hand
	sed -i -e '/{"regex": \/foo.*\/}/d' test/json_test.rb || die
	sed -i -e '/{"regex": \/foo.*\/i}/d' test/json_test.rb || die
	sed -i -e '/{"regex": \/foo.*\/mix}/d' test/json_test.rb || die
}

each_ruby_test() {
	${RUBY} -Itest -Ilib -e 'Dir["test/*_test.rb"].each { |f| load f }' || die
}
