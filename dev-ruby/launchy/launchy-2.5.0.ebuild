# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md HISTORY.md"

inherit ruby-fakegem

DESCRIPTION="Helper class for launching cross-platform applications"
HOMEPAGE="https://github.com/copiousfreetime/launchy"

LICENSE="ISC"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/addressable-2.7"

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
