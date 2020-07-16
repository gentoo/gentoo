# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md VERSIONS.md"

RUBY_FAKEGEM_EXTRAINSTALL="vendor"

RUBY_FAKEGEM_GEMSPEC="jquery-rails.gemspec"

inherit ruby-fakegem

DESCRIPTION="jQuery! For Rails! So great"
HOMEPAGE="https://www.rubyonrails.org"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux"

IUSE=""

ruby_add_rdepend "
	>=dev-ruby/railties-4.2.0:*
	>=dev-ruby/thor-0.14 <dev-ruby/thor-2
	dev-ruby/rails-dom-testing:2"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' jquery-rails.gemspec || die
}
