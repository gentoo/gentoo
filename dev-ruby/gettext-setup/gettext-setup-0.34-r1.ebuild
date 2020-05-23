# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A gem to ease i18n"
HOMEPAGE="https://github.com/puppetlabs/gettext-setup-gem"
SRC_URI="https://github.com/puppetlabs/gettext-setup-gem/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-gem-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND+=" dev-vcs/git"
DEPEND+=" test? ( dev-vcs/git )"

ruby_add_rdepend "
	>=dev-ruby/fast_gettext-1.1.0:0
	>=dev-ruby/ruby-gettext-3.0.2
	dev-ruby/locale
"

all_ruby_prepare() {
	sed -i -e 's/1.1.0/1.1/' \
		-e "s/spec.version.*$/spec.version = '${PV}'/" ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/simplecov/,/^end/ s:^:#: ; 1irequire "date"' spec/spec_helper.rb || die

	# Avoid spec with specific locale requirements
	sed -i -e '/can clear the locale/,/^    end/ s:^:#:' spec/lib/gettext-setup/gettext_setup_spec.rb || die
}
