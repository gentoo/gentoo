# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby GOffice bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/goffice[introspection]"
RDEPEND+=" x11-libs/goffice[introspection]"

ruby_add_rdepend "
	~dev-ruby/ruby-gsf-${PV}
	~dev-ruby/ruby-gtk3-${PV}"

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare

	# https://github.com/ruby-gnome/ruby-gnome/issues/1316
	sed -i -e '/only_goffice_version/s/0, 10, 27/0, 10/' \
		test/test-data-scalar-str.rb
}
