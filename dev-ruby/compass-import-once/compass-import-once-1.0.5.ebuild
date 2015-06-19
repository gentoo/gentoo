# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/compass-import-once/compass-import-once-1.0.5.ebuild,v 1.1 2014/10/05 06:56:19 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

# Skip tests since they depend on sass-globbing which does not have a
# license and where the last version is known to be broken.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="VERSION"

inherit ruby-fakegem versionator

DESCRIPTION="Speed up your Sass compilation by making @import only import each file once"
HOMEPAGE="http://compass-style.org/"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/sass-3.2 <dev-ruby/sass-3.5
"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}
