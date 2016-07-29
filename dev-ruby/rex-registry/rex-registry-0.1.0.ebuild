# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"
#RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="Rex library for parsing offline registry files from a Windows machine"
HOMEPAGE="https://rubygems.org/gems/rex-registry"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# doesn't seem to actually run any tests
RESTRICT=test

all_ruby_install() {
	ruby_fakegem_binwrapper console ${PN}-console
	ruby_fakegem_binwrapper setup ${PN}-setup
}
