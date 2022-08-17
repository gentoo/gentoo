# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTENSIONS=(ext/tidy/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="W3C HTML Tidy library implemented as a Ruby extension"
HOMEPAGE="https://github.com/carld/tidy"

LICENSE="HTML-Tidy"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~sparc x86"
IUSE=""

PATCHES=( "${FILESDIR}/11CVE-2015-5522.patch" )

all_ruby_prepare() {
	mkdir lib || die

	# Remove reference to rspec 1
	sed -i -e '/spec/d' spec/spec_helper.rb || die

	# Avoid spec that needs network connectivity.
	rm spec/tidy/remote_uri_spec.rb || die

	# rspec 3 compatibility
	sed -i -e 's/be_true/be_truthy/' spec/tidy/compat_spec.rb || die
}
