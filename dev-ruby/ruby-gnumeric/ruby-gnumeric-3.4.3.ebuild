# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Gnumeric bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" app-office/gnumeric[introspection]"
RDEPEND+=" app-office/gnumeric[introspection]"

ruby_add_bdepend "~dev-ruby/ruby-goffice-${PV}"
ruby_add_rdepend "~dev-ruby/ruby-goffice-${PV}"

# Test is currently disabled.
# https://github.com/ruby-gnome/ruby-gnome/blob/master/gnumeric/test/test-convert.rb#L27
each_ruby_test() {
	:
}
