# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md HISTORY.md"
RUBY_FAKEGEM_GEMSPEC="launchy.gemspec"

inherit ruby-fakegem virtualx

DESCRIPTION="Helper class for launching cross-platform applications"
HOMEPAGE="https://github.com/copiousfreetime/launchy"
SRC_URI="https://github.com/copiousfreetime/launchy/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/addressable-2.8
	dev-ruby/childprocess:5
	!<dev-ruby/launchy-2.5.2-r1
"

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.0:5 )"

all_ruby_prepare() {
	sed -i -e "/[Ss]implecov/d" spec/spec_helper.rb || die

	# Avoid tests depending on the current user's desktop environment.
	sed -e '/returns NotFound if it cannot determine/askip "gentoo"' \
		-i spec/detect/nix_desktop_environment_spec.rb || die
	sed -e '/asssumes we open a local file if we have an exception/askip "gentoo"' \
		-i spec/launchy_spec.rb || die
	sed -e "/'darwin'/ s:^:#:" \
		-i spec/applications/browser_spec.rb || die
}

each_ruby_test() {
	CI=true virtx each_fakegem_test
}
