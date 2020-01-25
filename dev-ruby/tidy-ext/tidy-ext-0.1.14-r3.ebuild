# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_DOCDIR="rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem eutils

DESCRIPTION="W3C HTML Tidy library implemented as a Ruby extension"
HOMEPAGE="https://github.com/carld/tidy"

LICENSE="HTML-Tidy"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 ~sparc x86"
IUSE=""

RUBY_PATCHES=( 11CVE-2015-5522.patch )

all_ruby_prepare() {
	mkdir lib || die

	# Remove reference to rspec 1
	sed -i -e '/spec/d' spec/spec_helper.rb || die

	# Avoid spec that needs network connectivity.
	rm spec/tidy/remote_uri_spec.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/tidy extconf.rb || die "Unable to configure extension."
}

each_ruby_compile() {
	emake -Cext/tidy V=1
	cp ext/tidy/tidy$(get_modname) lib/ || die "Unable to copy extension."
}
